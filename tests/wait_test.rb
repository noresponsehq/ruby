# typed: ignore
# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'faraday'
require 'noresponse'

class WaitTest < Minitest::Test
  FIXTURES = File.join(__dir__, 'fixtures')
  PENDING = File.read(File.join(FIXTURES, 'valid/assessment-pending.json'))
  COMPLETE = File.read(File.join(FIXTURES, 'valid/assessment-complete.json'))
  ID = JSON.parse(COMPLETE)['assessment_id']

  def client(responses)
    seen = []
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/v1/assessments/#{ID}") do |env|
        seen << env
        status, body, headers = responses[[seen.length, responses.length].min - 1]
        [status, { 'Content-Type' => 'application/json' }.merge(headers), body]
      end
    end
    faraday = Faraday.new { |f| f.adapter(:test, stubs) }
    sdk = NoResponse::NoResponse.new(client: faraday, api_key: "nrk_test_#{'k' * 20}", server_url: 'https://api.example.test')
    [sdk, seen]
  end

  def fake_time
    now = 0.0
    slept = []
    sleeper = lambda do |seconds|
      slept << seconds
      now += seconds
    end
    [slept, sleeper, -> { now }]
  end

  def test_polls_until_complete_honouring_retry_after
    sdk, seen = client([[200, PENDING, { 'Retry-After' => '3' }], [200, PENDING, { 'Retry-After' => '0' }], [200, COMPLETE, {}]])
    slept, sleeper, clock = fake_time
    result = NoResponse::Wait.wait(sdk, ID, sleeper: sleeper, clock: clock)
    assert_equal NoResponse::Models::Shared::Status::COMPLETE, result.status
    assert_equal ID, result.assessment_id
    assert_equal [3.0, 1.0], slept
    assert_equal 3, seen.length
    assert_equal "Bearer nrk_test_#{'k' * 20}", seen.first.request_headers['Authorization']
  end

  def test_times_out_with_the_last_pending_assessment
    sdk, = client([[200, PENDING, { 'Retry-After' => '2' }]])
    slept, sleeper, clock = fake_time
    error = assert_raises(NoResponse::WaitTimeoutError) { NoResponse::Wait.wait(sdk, ID, timeout: 5, sleeper: sleeper, clock: clock) }
    assert_equal NoResponse::Models::Shared::Status::PENDING, error.last.status
    assert_equal [2.0, 2.0], slept
  end
end
