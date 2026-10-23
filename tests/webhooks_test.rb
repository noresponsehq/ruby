# typed: ignore
# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'openssl'
require 'noresponse'

class WebhooksTest < Minitest::Test
  FIXTURES = File.join(__dir__, 'fixtures')
  VECTOR = JSON.parse(File.read(File.join(FIXTURES, 'webhook-signature-vector.json')))
  PAYLOAD = VECTOR['payload']
  SECRETS = { VECTOR['key_id'] => VECTOR['secret_utf8'] }.freeze
  HEADERS = VECTOR['headers']
  NOW = VECTOR['timestamp'].to_i
  Webhooks = NoResponse::Webhooks

  def fixture(name) = JSON.parse(File.read(File.join(FIXTURES, name)))

  def signed(body, secret, id, key_id = 'whk_sdktest01', timestamp = '1791968402')
    raw = JSON.generate(body)
    digest = OpenSSL::HMAC.hexdigest('SHA256', secret, "#{timestamp}.#{raw}")
    [raw, [['NR-Webhook-Id', id], ['NR-Webhook-Timestamp', timestamp], ['NR-Webhook-Key-Id', key_id],
           ['NR-Webhook-Signature', "v1=#{digest}"]]]
  end

  def refused(code, *args, **kwargs)
    error = assert_raises(Webhooks::VerificationError) { Webhooks.construct_event(*args, **kwargs) }
    assert_equal code, error.code, error.message
  end

  def test_shared_vector_yields_typed_assessment
    event = Webhooks.construct_event(PAYLOAD, HEADERS, SECRETS, now: NOW)
    assert_equal 'assessment.updated', event.type
    assert_equal HEADERS['NR-Webhook-Id'], event.id
    assert_equal '2026-10-14T09:00:02.000Z', event.created_at
    assert_instance_of NoResponse::Models::Shared::Assessment, event.data
    assert_equal 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM', event.data.assessment_id
    assert_equal 2, event.data.assessment_version
    assert_equal NoResponse::Models::Shared::Recommendation::STEP_UP, event.data.risk.recommendation
    refute event.expired?
    # Rack env names verify the same delivery.
    rack = HEADERS.transform_keys { |name| "HTTP_#{name.upcase.tr('-', '_')}" }
    assert_equal event.id, Webhooks.construct_event(PAYLOAD, rack, SECRETS, now: NOW).id
  end

  def test_refusals
    refused(:invalid_signature, "#{PAYLOAD} ", HEADERS, SECRETS, now: NOW)
    refused(:invalid_timestamp, PAYLOAD, HEADERS, SECRETS, now: NOW + 301)
    refused(:invalid_timestamp, PAYLOAD, HEADERS, SECRETS, now: NOW - 301)
    assert_equal HEADERS['NR-Webhook-Id'],
                 Webhooks.construct_event(PAYLOAD, HEADERS, SECRETS, now: NOW + 301, tolerance_seconds: 600).id
    refused(:duplicate_header, PAYLOAD, HEADERS.to_a + [%w[nr-webhook-id duplicate]], SECRETS, now: NOW)
    refused(:duplicate_header, PAYLOAD, HEADERS.to_a + [['nr-webhook-ID', HEADERS['NR-Webhook-Id']]], SECRETS, now: NOW)
    refused(:duplicate_header, PAYLOAD, HEADERS.merge('NR-Webhook-Id' => [HEADERS['NR-Webhook-Id']] * 2), SECRETS,
            now: NOW)
    refused(:missing_header, PAYLOAD, HEADERS.except('NR-Webhook-Signature'), SECRETS, now: NOW)
    refused(:unknown_key, PAYLOAD, HEADERS, { 'whk_other0001' => VECTOR['secret_utf8'] }, now: NOW)
    refused(:invalid_signature, PAYLOAD, HEADERS, { VECTOR['key_id'] => 'other-secret' }, now: NOW)
    refused(:invalid_signature, PAYLOAD, HEADERS.merge('NR-Webhook-Signature' => 'v2=abc'), SECRETS, now: NOW)
  end

  def test_rotation_and_event_id
    complete = fixture('valid/assessment-complete.json')
    event = { 'id' => 'evt_01JA2ZB4N5P6Q7R8S9T0VWXYZ2', 'type' => 'assessment.updated',
              'created_at' => '2026-10-18T11:00:04Z', 'data' => complete }
    both = { 'whk_sdktest01' => 'old-secret', 'whk_sdktest02' => 'new-secret' }
    raw, headers = signed(event, 'new-secret', event['id'], 'whk_sdktest02')
    assert_equal complete['assessment_id'], Webhooks.construct_event(raw, headers, both, now: NOW).data.assessment_id
    raw, headers = signed(event, 'new-secret', 'evt_01JA2ZB4N5P6Q7R8S9T0VWXYZ9', 'whk_sdktest02')
    refused(:invalid_payload, raw, headers, both, now: NOW)
    pointer = event.merge('data' => { 'assessment_id' => complete['assessment_id'], 'assessment_url' => '/v1/assessments/x' })
    raw, headers = signed(pointer, 'new-secret', event['id'], 'whk_sdktest02')
    refused(:invalid_payload, raw, headers, both, now: NOW)
  end

  def test_expired_and_verification_events
    expired = fixture('valid/webhook-assessment-expired.json')
    raw, headers = signed(expired, 'secret', expired['id'])
    event = Webhooks.construct_event(raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW)
    assert_predicate event, :expired?
    assert_equal expired['data']['account_id'], event.data.account_id
    assert_equal 2, event.data.assessment_version
    assert_raises(Webhooks::VerificationError) { Webhooks.verification_response(event) }

    ping = fixture('valid/webhook-endpoint-verification.json')
    raw, headers = signed(ping, 'secret', ping['id'])
    event = Webhooks.construct_event(raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW)
    assert_equal 'endpoint.verification', event.type
    assert_equal ping['data']['endpoint_id'], event.data.endpoint_id
    assert_equal({ 'challenge' => ping['data']['challenge'] }, Webhooks.verification_response(event))
  end

  # The API adds fields without a new version, so keys this SDK does not know
  # must not stop a signed event from verifying.
  def test_unknown_fields_are_accepted
    %w[
      invalid/webhook-tenant-id.json
      invalid/webhook-identifier-leak.json
      invalid/webhook-expired-with-assessment-url.json
    ].each do |name|
      body = fixture(name)
      raw, headers = signed(body, 'secret', body['id'])
      assert_equal body['id'], Webhooks.construct_event(raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW).id
    end
  end

  def test_contract_invalid_fixtures_and_malformed_identifiers_are_refused
    invalid = %w[
      invalid/webhook-update-names-source.json
      invalid/webhook-unknown-event-type.json
      invalid/webhook-update-pointer-only.json
      invalid/webhook-update-with-expired-status.json
      invalid/webhook-verification-without-challenge.json
    ]
    invalid.each do |name|
      body = fixture(name)
      raw, headers = signed(body, 'secret', body['id'])
      refused(:invalid_payload, raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW)
    end

    endpoint = fixture('valid/webhook-endpoint-verification.json')
    endpoint['id'] = 'evt_bad'
    raw, headers = signed(endpoint, 'secret', endpoint['id'])
    refused(:invalid_payload, raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW)

    endpoint = fixture('valid/webhook-endpoint-verification.json')
    endpoint['data']['endpoint_id'] = 'whe_bad'
    raw, headers = signed(endpoint, 'secret', endpoint['id'])
    refused(:invalid_payload, raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW)

    endpoint = fixture('valid/webhook-endpoint-verification.json')
    endpoint['created_at'] = 'tomorrow'
    raw, headers = signed(endpoint, 'secret', endpoint['id'])
    refused(:invalid_payload, raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW)

    endpoint = fixture('valid/webhook-endpoint-verification.json')
    endpoint['created_at'] = '2026-10-14'
    raw, headers = signed(endpoint, 'secret', endpoint['id'])
    refused(:invalid_payload, raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW)
  end

  def test_a_test_event_says_so_and_a_real_one_does_not
    sample = fixture('valid/webhook-assessment-updated-test.json')
    raw, headers = signed(sample, 'secret', sample['id'])
    event = Webhooks.construct_event(raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW)
    assert_predicate event, :test?
    assert_instance_of NoResponse::Models::Shared::Assessment, event.data

    real = fixture('valid/webhook-assessment-updated.json')
    raw, headers = signed(real, 'secret', real['id'])
    refute_predicate Webhooks.construct_event(raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW), :test?

    ping = fixture('valid/webhook-endpoint-verification.json').merge('test' => true)
    raw, headers = signed(ping, 'secret', ping['id'])
    refute_predicate Webhooks.construct_event(raw, headers, { 'whk_sdktest01' => 'secret' }, now: NOW), :test?
  end
end
