# typed: ignore
# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'faraday'
require 'noresponse'

class ClientTest < Minitest::Test
  FIXTURES = File.join(__dir__, 'fixtures')
  COMPLETE = File.read(File.join(FIXTURES, 'valid/assessment-complete.json'))
  PENDING = File.read(File.join(FIXTURES, 'valid/assessment-pending.json'))
  ID = JSON.parse(COMPLETE)['assessment_id']
  UUID = /\A\h{8}-\h{4}-4\h{3}-[89ab]\h{3}-\h{12}\z/
  JSON_TYPE = { 'Content-Type' => 'application/json' }.freeze
  PROBLEM_TYPE = { 'Content-Type' => 'application/problem+json' }.freeze

  def sdk(stubs)
    faraday = Faraday.new { |f| f.adapter(:test, stubs) }
    NoResponse::NoResponseClient.new(client: faraday, api_key: "nrk_test_#{'k' * 20}", server_url: 'https://api.example.test')
  end

  def request
    NoResponse::Models::Shared::AssessmentRequest.new(
      account_id: 'acct_7f3a9c',
      identifiers: NoResponse::Models::Shared::AssessmentRequestIdentifiers.new(email: 'new.user@example.com')
    )
  end

  def test_create_sends_a_generated_idempotency_key
    seen = []
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post('/v1/assessments') do |env|
        seen << env.request_headers['Idempotency-Key']
        [200, JSON_TYPE, COMPLETE]
      end
    end
    client = sdk(stubs)
    client.assessments.create(body: request)
    client.assessments.create(body: request)
    assert_equal 2, seen.length
    seen.each { |key| assert_match UUID, key }
    refute_equal seen[0], seen[1]
  end

  def test_create_keeps_the_callers_idempotency_key
    seen = nil
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post('/v1/assessments') do |env|
        seen = env.request_headers['Idempotency-Key']
        [200, JSON_TYPE, COMPLETE]
      end
    end
    sdk(stubs).assessments.create(body: request, idempotency_key: 'signup-usr_8f2k1-0001')
    assert_equal 'signup-usr_8f2k1-0001', seen
  end

  def test_a_retry_sends_the_same_idempotency_key
    seen = []
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post('/v1/assessments') do |env|
        seen << env.request_headers['Idempotency-Key']
        seen.length == 1 ? [503, PROBLEM_TYPE, '{}'] : [200, JSON_TYPE, COMPLETE]
      end
    end
    retry_config = NoResponse::Utils::RetryConfig.new(
      strategy: 'backoff',
      backoff: NoResponse::Utils::BackoffStrategy.new(initial_interval: 1, max_interval: 5, exponent: 1.1, max_elapsed_time: 1000),
      retry_connection_errors: false
    )
    sdk(stubs).assessments.create(body: request, retries: retry_config)
    assert_equal 2, seen.length
    assert_equal seen[0], seen[1]
  end

  def test_assessments_wait_polls_through_the_resource
    responses = [[200, PENDING, { 'Retry-After' => '2' }], [200, COMPLETE, {}]]
    calls = 0
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/v1/assessments/#{ID}") do
        status, body, headers = responses[[calls += 1, responses.length].min - 1]
        [status, JSON_TYPE.merge(headers), body]
      end
    end
    slept = []
    result = sdk(stubs).assessments.wait(ID, sleeper: ->(seconds) { slept << seconds }, clock: -> { 0.0 })
    assert_equal ID, result.assessment_id
    assert_equal [2.0], slept
  end

  def test_every_api_error_is_a_no_response_error
    problem = {
      type: 'https://docs.noresponse.org/errors/not_found', title: 'Not found', status: 404,
      detail: 'No such assessment.', code: 'not_found', request_id: 'a' * 32
    }.to_json
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/v1/assessments/#{ID}") { [404, PROBLEM_TYPE, problem] }
    end
    error = assert_raises(NoResponse::Models::Errors::NoResponseError) { sdk(stubs).assessments.get(assessment_id: ID) }
    assert_instance_of NoResponse::Models::Errors::NotFoundError, error
    assert_equal 'a' * 32, error.request_id
  end
end
