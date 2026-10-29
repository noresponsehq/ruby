# typed: ignore
# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'faraday'
require 'noresponse'

class IdentifierSearchTest < Minitest::Test
  def test_both_searches_preserve_generated_identifier_and_match_types
    models = NoResponse::Models::Shared
    revision = JSON.parse(File.read(File.join(__dir__, 'fixtures', 'investigation-responses.json')))['revision']
    identifier = { 'kind' => 'username', 'value' => 'janedoe', 'match' => 'canonical', 'namespace' => 'customer' }
    matched = { 'kind' => 'username', 'value' => 'JaneDoe', 'match_basis' => 'canonical', 'namespace' => 'customer', 'provenance' => 'submitted', 'assessment_id' => revision['id'] }
    requests = []
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      ['/v1/accounts/search', '/v1/assessments/search'].each do |path|
        stub.post(path) do |env|
          assert_equal 'Bearer nrk_test_identifier_fixture', env.request_headers['Authorization']
          requests << JSON.parse(env.body)
          item = path.include?('/accounts/') ? { 'account_id' => 'acct_7f3a9c', 'latest' => revision, 'assessments' => 2, 'matched_identifier' => matched } : revision.merge('matched_identifier' => matched)
          page = { 'schema_version' => '1', 'items' => [item], 'total' => 1, 'total_capped' => false }
          page['retention_days'] = 365 if path == '/v1/assessments/search'
          [200, { 'Content-Type' => 'application/json' }, page.to_json]
        end
      end
    end
    client = NoResponse::NoResponseClient.new(client: Faraday.new { |f| f.adapter(:test, stubs) }, api_key: 'nrk_test_identifier_fixture', server_url: 'https://api.example.test')
    query = Crystalline.unmarshal_json(identifier, models::IdentifierSearch)
    accounts = client.accounts.search(request: models::AccountDirectorySearchRequest.new(identifier: query)).result
    assessments = client.assessments.search(request: models::AssessmentSearchRequest.new(from: '2026-10-01T00:00:00Z', to: '2026-10-02T00:00:00Z', identifier: query)).result
    [accounts.items[0].matched_identifier, assessments.items[0].matched_identifier].each do |found|
      assert_instance_of models::IdentifierMatch, found
      assert_equal matched, JSON.parse(found.to_json)
    end
    assert_nil accounts.items[0].current
    assert_equal 2, requests.length
    requests.each { |sent| assert_equal identifier, sent['identifier'] }
    stubs.verify_stubbed_calls
  end
end
