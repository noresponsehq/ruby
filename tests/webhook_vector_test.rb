# typed: ignore
# frozen_string_literal: true

# The contract's signature vector through the generated webhook verifier.

require 'minitest/autorun'
require 'json'
require 'openssl'
require 'noresponse'

class WebhookVectorTest < Minitest::Test
  FIXTURES = File.join(__dir__, 'fixtures')
  VECTOR = JSON.parse(File.read(File.join(FIXTURES, 'webhook-signature-vector.json')))
  PAYLOAD = VECTOR['payload']
  HEADERS = VECTOR['headers']
  SECRETS = { VECTOR['key_id'] => VECTOR['secret_utf8'] }.freeze
  NOW = VECTOR['timestamp'].to_i
  Verification = NoResponse::WebhookVerification
  Shared = NoResponse::Models::Shared
  EVENT_CLASSES = {
    'assessment.updated' => Shared::AssessmentUpdatedEvent,
    'endpoint.verification' => Shared::EndpointVerificationEvent,
    'account.deleted' => Shared::AccountDeletedEvent,
    'workspace.deleted' => Shared::WorkspaceDeletedEvent,
    'webhook_endpoint.disabled' => Shared::WebhookEndpointDisabledEvent,
    'account.risk_changed' => Shared::AccountRiskChangedEvent,
    'audit.event' => Shared::AuditEventEvent
  }.freeze

  def test_the_vector_verifies_into_a_typed_assessment_event
    event = Verification.construct_event(PAYLOAD, HEADERS, SECRETS, now: NOW)
    assert_instance_of NoResponse::Models::Shared::AssessmentUpdatedEvent, event
    assert_equal 'assessment.updated', event.type
    assert_equal 'asm_01JA2Z8K6Q4V7W9XBCDEFGHJKM', event.data.id
    assert_equal 2, event.data.detail.assessment_version
  end

  def test_a_tampered_stale_unknown_or_repeated_delivery_is_refused
    cases = {
      'invalid_signature' => ["#{PAYLOAD} ", HEADERS, SECRETS, NOW],
      'invalid_timestamp' => [PAYLOAD, HEADERS, SECRETS, NOW + 301],
      'unknown_key' => [PAYLOAD, HEADERS, { 'whk_other0001' => VECTOR['secret_utf8'] }, NOW],
      'duplicate_header' => [PAYLOAD, HEADERS.merge('nr-webhook-signature' => HEADERS['NR-Webhook-Signature']), SECRETS, NOW],
      'missing_header' => [PAYLOAD, HEADERS.reject { |name, _| name == 'NR-Webhook-Id' }, SECRETS, NOW]
    }
    cases.each do |code, (payload, headers, secrets, now)|
      error = assert_raises(Verification::VerificationError, code) do
        Verification.construct_event(payload, headers, secrets, now: now)
      end
      assert_equal code, error.code
    end
  end

  def test_every_contract_event_fixture_parses_into_its_typed_event
    names = Dir[File.join(FIXTURES, 'valid', 'webhook-*.json')].sort
    bodies = names.map { |name| JSON.parse(File.read(name)) }.select { |body| body['type'] }
    refute_empty bodies
    bodies.each do |body|
      raw = JSON.generate(body)
      signature = "v1=#{OpenSSL::HMAC.hexdigest('SHA256', 'fixture-secret', "#{NOW}.#{raw}")}"
      headers = { 'NR-Webhook-Id' => body['id'], 'NR-Webhook-Timestamp' => NOW.to_s,
                  'NR-Webhook-Key-Id' => 'whk_fixture0001', 'NR-Webhook-Signature' => signature }
      event = Verification.construct_event(raw, headers, { 'whk_fixture0001' => 'fixture-secret' }, now: NOW)
      assert_equal body['type'], event.type
      assert_instance_of EVENT_CLASSES.fetch(body['type']), event
      assert_equal body, JSON.parse(event.to_json), "#{body['id']}: the typed event differs from the fixture"
    end
  end
end
