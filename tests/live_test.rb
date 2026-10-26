# typed: ignore
# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'securerandom'
require 'noresponse'

# Consumer smoke test of the client against a live API.
#
# Skipped unless NORESPONSE_LIVE_URL and NORESPONSE_LIVE_API_KEY name an API
# and a key with the assess and history scopes (a test key keeps it off real
# sources). It assesses a synthetic account, replays the request, reads it
# back, waits for it to settle, lists its history and checks the typed 404.
# NORESPONSE_LIVE_WEBHOOK_VECTORS names deliveries the same API signed, in
# the shape of webhook-signature-vector.json, for the verifier. Each step
# writes its name to NORESPONSE_LIVE_REPORT, and "done" at the end, so a
# failure names the operation (integrations/regression/suites/sdks.sh).
class LiveTest < Minitest::Test
  Shared = NoResponse::Models::Shared
  Verification = NoResponse::WebhookVerification

  def step(name)
    report = ENV.fetch('NORESPONSE_LIVE_REPORT', '')
    File.write(report, name) unless report.empty?
  end

  # The string value of an open enum, which a client may hold as a T::Enum or as a string.
  def value(enum)
    enum.respond_to?(:serialize) ? enum.serialize : enum
  end

  def test_a_consumer_assesses_waits_for_and_lists_an_account
    url = ENV.fetch('NORESPONSE_LIVE_URL', '')
    key = ENV.fetch('NORESPONSE_LIVE_API_KEY', '')
    skip 'set NORESPONSE_LIVE_URL and NORESPONSE_LIVE_API_KEY to run against a live API' if url.empty? || key.empty?
    client = NoResponse::NoResponseClient.new(api_key: key, server_url: url)
    account_id = "sdk-live-ruby-#{ENV.fetch('NORESPONSE_LIVE_RUN') { SecureRandom.hex(4) }}"
    idempotency_key = "sdk-live-#{SecureRandom.hex(16)}"
    request = Shared::AssessmentRequest.new(
      flow: Shared::Flow::ACCOUNT_CREATION,
      account_id: account_id,
      identifiers: Shared::AssessmentRequestIdentifiers.new(email: 'sdk-live@example.com')
    )

    step 'create'
    created = client.assessments.create(body: request, idempotency_key: idempotency_key).result
    assert_match(/\Aasm_/, created.id)
    assert_equal account_id, created.detail.account_id

    step 'replay'
    assert_equal created.id, client.assessments.create(body: request, idempotency_key: idempotency_key).result.id

    step 'get'
    assert_equal created.id, client.assessments.get(assessment_id: created.id).result.id

    step 'wait'
    settled = client.assessments.wait(created.id, timeout: 60)
    assert_includes %w[complete partial], value(settled.status)
    refute_nil settled.account

    step 'query'
    history = client.assessments.query(request: Shared::AssessmentQuery.new(account_id: account_id, limit: 5)).result.items
    assert_includes history.map(&:assessment_id), created.id
    assert_equal [account_id], history.map(&:account_id).uniq

    step 'list_account_assessments'
    page = client.accounts.list_assessments(account_id: account_id, limit: 5).result.items
    assert_includes page.map(&:assessment_id), created.id

    step 'get_account'
    account = client.accounts.get(account_id: account_id).result
    assert_equal account_id, account.id
    assert_equal value(settled.account.risk.decision), value(account.risk.decision)

    step 'not_found'
    missing = assert_raises(NoResponse::Models::Errors::NotFoundError) do
      client.assessments.get(assessment_id: "asm_#{'0' * 26}")
    end
    assert_equal 404, missing.status
    refute_empty missing.request_id

    vectors = ENV.fetch('NORESPONSE_LIVE_WEBHOOK_VECTORS', '')
    (vectors.empty? ? [] : JSON.parse(File.read(vectors))).each do |vector|
      step "verify_webhook #{vector['type']}"
      secrets = { vector['key_id'] => vector['secret_utf8'] }
      now = vector['timestamp'].to_i
      assert_equal vector['type'], Verification.construct_event(vector['payload'], vector['headers'], secrets, now: now).type
      refused = assert_raises(Verification::VerificationError) do
        Verification.construct_event("#{vector['payload']} ", vector['headers'], secrets, now: now)
      end
      assert_equal 'invalid_signature', refused.code
    end
    step 'done'
  end
end
