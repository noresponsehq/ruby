# typed: ignore
# frozen_string_literal: true

require 'minitest/autorun'
require 'noresponse'

# Smoke test of the client against the mock server.
#
# Skipped unless NORESPONSE_MOCK_URL names a running mock server
# (`generate_sdks.py mockserver --serve`). The mock server answers with the
# examples in the SDK document, so this proves the client's wiring (URL, auth
# header, request encoding, response parsing) and nothing about the live API.
class MockServerTest < Minitest::Test
  Models = ::NoResponse::Models

  def client
    url = ENV.fetch('NORESPONSE_MOCK_URL', '')
    skip 'set NORESPONSE_MOCK_URL to a running mock server' if url.empty?
    NoResponse::NoResponseClient.new(api_key: "nrk_mock_#{'k' * 20}", server_url: url)
  end

  def test_create_returns_the_documented_assessment
    res = client.assessments.create(
      idempotency_key: 'mock-server-smoke-0001',
      body: Models::Shared::AssessmentRequest.new(
        flow: Models::Shared::Flow::ACCOUNT_CREATION,
        account_id: 'acct_7f3a9c',
        identifiers: Models::Shared::AssessmentRequestIdentifiers.new(email: 'new.user@example.com')
      )
    )
    assert_match(/\Aasm_/, res.result.id)
    assert_equal 'acct_7f3a9c', res.result.detail.account_id
  end

  def test_get_returns_the_documented_assessment
    res = client.assessments.get(assessment_id: 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM')
    assert_match(/\Aasm_/, res.result.id)
  end
end
