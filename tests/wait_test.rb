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
  PARTIAL = File.read(File.join(FIXTURES, 'valid/assessment-partial.json'))
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
    sdk = NoResponse::NoResponseClient.new(client: faraday, api_key: "nrk_test_#{'k' * 20}", server_url: 'https://api.example.test')
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

  def test_keeps_polling_a_partial_answer_until_complete
    sdk, seen = client([[200, PARTIAL, {}], [200, PARTIAL, { 'Retry-After' => '2' }], [200, COMPLETE, {}]])
    slept, sleeper, clock = fake_time
    result = NoResponse::Wait.wait(sdk, ID, sleeper: sleeper, clock: clock)
    assert_equal NoResponse::Models::Shared::Status::COMPLETE, result.status
    assert_equal [1.0, 2.0], slept
    assert_equal 3, seen.length
  end

  def test_returns_the_latest_partial_answer_at_the_timeout
    sdk, seen = client([[200, PENDING, { 'Retry-After' => '1' }], [200, PARTIAL, {}]])
    slept, sleeper, clock = fake_time
    result = sdk.assessments.wait(ID, timeout: 3.5, sleeper: sleeper, clock: clock)
    assert_equal NoResponse::Models::Shared::Status::PARTIAL, result.status
    assert_equal [1.0, 1.0, 1.0], slept
    assert_equal 4, seen.length
  end

  # Stands in for client.assessments: answers each get from the list, where a
  # Class entry is raised as that error after moving the clock to the deadline.
  class FakeAssessments
    Response = Struct.new(:result, :headers)

    def initialize(answers, advance)
      @answers = answers
      @advance = advance
    end

    def get(assessment_id:, timeout_ms:)
      answer = @answers.shift
      if answer.is_a?(Class)
        @advance.call(timeout_ms / 1000.0)
        raise answer, 'request timed out'
      end
      Response.new(Crystalline.unmarshal_json(JSON.parse(answer), NoResponse::Models::Shared::Assessment), {})
    end
  end

  def test_a_poll_cut_off_by_the_deadline_returns_the_last_partial_answer
    _, sleeper, clock = fake_time
    assessments = FakeAssessments.new([PARTIAL, Faraday::TimeoutError], sleeper)
    result = NoResponse::Wait.poll(assessments, ID, timeout: 1.5, sleeper: sleeper, clock: clock)
    assert_equal NoResponse::Models::Shared::Status::PARTIAL, result.status
  end

  def test_a_poll_cut_off_by_the_deadline_still_raises_with_nothing_partial
    _, sleeper, clock = fake_time
    assessments = FakeAssessments.new([PENDING, Faraday::TimeoutError], sleeper)
    assert_raises(Faraday::TimeoutError) { NoResponse::Wait.poll(assessments, ID, timeout: 1.5, sleeper: sleeper, clock: clock) }
    early = FakeAssessments.new([Faraday::ConnectionFailed], ->(_) {})
    assert_raises(Faraday::ConnectionFailed) { NoResponse::Wait.poll(early, ID, timeout: 1.5, sleeper: sleeper, clock: clock) }
  end
end
