# typed: true
# frozen_string_literal: true

# Webhook verification. Hand-written beside the generated client.
#
# Verify the exact bytes received: the signature is HMAC-SHA256 over
# "<timestamp>.<raw body>", so re-serialising parsed JSON breaks it.

require 'json'
require 'openssl'
require 'time'

module NoResponse
  module Webhooks
    DEFAULT_TOLERANCE_SECONDS = 300

    REQUIRED = %w[nr-webhook-id nr-webhook-timestamp nr-webhook-key-id nr-webhook-signature].freeze
    KEY_ID = /\Awhk_[A-Za-z0-9]{8,64}\z/
    SIGNATURE = /\Av1=[0-9a-f]{64}\z/
    TIMESTAMP = /\A[0-9]{1,12}\z/
    CHALLENGE = /\A[A-Za-z0-9_-]{43}\z/
    EVENT_ID = /\Aevt_[0-9A-HJKMNP-TV-Z]{26}\z/
    ASSESSMENT_ID = /\Aasm_[0-9A-HJKMNP-TV-Z]{26}\z/
    ACCOUNT_ID = /\A[A-Za-z0-9][A-Za-z0-9._:|-]{0,127}\z/
    ENDPOINT_ID = /\Awhe_[0-9A-HJKMNP-TV-Z]{26}\z/

    # Raised by construct_event. Answer 400 and do not process the delivery.
    # code is one of :missing_header, :duplicate_header, :invalid_timestamp,
    # :unknown_key, :invalid_signature or :invalid_payload.
    class VerificationError < StandardError
      attr_reader :code

      def initialize(code, message)
        super(message)
        @code = code
      end
    end

    # The final event for an assessment: it has expired and get now answers
    # 404. assessment_version is the last served version.
    AssessmentExpired = Struct.new(:assessment_id, :account_id, :assessment_version, keyword_init: true) do
      def status = 'expired'
      def change_reason = 'expired'
    end

    EndpointVerification = Struct.new(:endpoint_id, :challenge, keyword_init: true)

    # A verified delivery. data is a Models::Shared::Assessment (exactly as
    # assessments.get returns it) or an AssessmentExpired for type
    # "assessment.updated", and an EndpointVerification for
    # "endpoint.verification". Deliveries are at least once and unordered:
    # deduplicate on id and keep the highest assessment_version.
    Event = Struct.new(:id, :type, :created_at, :data, :test, keyword_init: true) do
      # True for the terminal expiry event: delete what you hold and fetch nothing.
      def expired? = data.is_a?(AssessmentExpired)

      # True on an event sent by the send-test-event call: data is a fixed
      # example assessment, not one of yours. Acknowledge it and apply nothing.
      def test? = test == true
    end

    class << self

      # Verify one delivery and return the typed Event.
      #
      # payload is the raw request body. headers is a Hash, Rack env-style
      # pairs or any object with each; each NR-Webhook-* header must appear
      # exactly once, in any letter case. secrets maps each whk_ key id
      # NoResponse gave you to its secret; hold both during a rotation.
      def construct_event(payload, headers, secrets, tolerance_seconds: DEFAULT_TOLERANCE_SECONDS, now: Time.now.to_i)
        raw = payload.to_s.b
        found = collect(headers)
        timestamp = found['nr-webhook-timestamp']
        if !TIMESTAMP.match?(timestamp) || (now.to_i - timestamp.to_i).abs > tolerance_seconds
          raise VerificationError.new(:invalid_timestamp, 'Webhook timestamp is outside the replay window')
        end

        key_id = found['nr-webhook-key-id']
        unless KEY_ID.match?(key_id) && secrets.key?(key_id)
          raise VerificationError.new(:unknown_key, 'Webhook key id is not one this receiver holds')
        end

        signature = found['nr-webhook-signature']
        raise VerificationError.new(:invalid_signature, 'Webhook signature is malformed') unless SIGNATURE.match?(signature)

        expected = OpenSSL::HMAC.hexdigest('SHA256', secrets.fetch(key_id).to_s, "#{timestamp}.".b + raw)
        unless OpenSSL.fixed_length_secure_compare(expected, signature.delete_prefix('v1='))
          raise VerificationError.new(:invalid_signature, 'Webhook signature does not match')
        end

        event(raw, found['nr-webhook-id'])
      end

      # The body to answer an endpoint.verification event with, as JSON, status 200.
      def verification_response(event)
        unless event.data.is_a?(EndpointVerification)
          raise VerificationError.new(:invalid_payload, 'Not an endpoint.verification event')
        end

        { 'challenge' => event.data.challenge }
      end

      private

      def collect(headers)
        found = {}
        headers.each do |name, value|
          key = name.to_s.downcase.tr('_', '-').delete_prefix('http-')
          next unless REQUIRED.include?(key)

          values = Array(value)
          if values.length != 1 || found.key?(key)
            raise VerificationError.new(:duplicate_header, "Webhook header #{key} is repeated")
          end

          found[key] = values.first.to_s
        end
        REQUIRED.each do |key|
          raise VerificationError.new(:missing_header, "Webhook header #{key} is missing") if found[key].to_s.empty?
        end
        found
      end

      def event(raw, header_id)
        body = begin
          JSON.parse(raw)
        rescue JSON::ParserError
          raise VerificationError.new(:invalid_payload, 'Webhook body is not JSON')
        end
        unless body.is_a?(Hash) && body['id'] == header_id && EVENT_ID.match?(body['id'].to_s)
          raise VerificationError.new(:invalid_payload, 'Webhook event id does not match NR-Webhook-Id')
        end

        data = body['data']
        unless body['created_at'].is_a?(String) && valid_datetime?(body['created_at']) && data.is_a?(Hash)
          raise VerificationError.new(:invalid_payload, 'Webhook event envelope is malformed')
        end

        Event.new(id: body['id'], type: body['type'], created_at: body['created_at'], data: event_data(body['type'], data),
                  test: body['test'] == true && body['type'] == 'assessment.updated')
      end

      def event_data(type, data)
        case type
        when 'endpoint.verification'
          unless ENDPOINT_ID.match?(data['endpoint_id'].to_s) && CHALLENGE.match?(data['challenge'].to_s)
            raise VerificationError.new(:invalid_payload, 'Endpoint verification event is malformed')
          end

          EndpointVerification.new(endpoint_id: data['endpoint_id'], challenge: data['challenge'])
        when 'assessment.updated'
          return expired(data) if data['status'] == 'expired'
          begin
            Crystalline.unmarshal_json(data, Models::Shared::Assessment)
          rescue KeyError, TypeError, ArgumentError, NoMethodError
            raise VerificationError.new(:invalid_payload, 'Webhook data is not an assessment')
          end
        else
          raise VerificationError.new(:invalid_payload, 'Unknown webhook event type')
        end
      end

      def expired(data)
        unless ASSESSMENT_ID.match?(data['assessment_id'].to_s) &&
               ACCOUNT_ID.match?(data['account_id'].to_s) && data['assessment_version'].is_a?(Integer) &&
               data['assessment_version'] >= 1 && data['status'] == 'expired' && data['change_reason'] == 'expired'
          raise VerificationError.new(:invalid_payload, 'Expired assessment event is malformed')
        end

        AssessmentExpired.new(assessment_id: data['assessment_id'], account_id: data['account_id'],
                              assessment_version: data['assessment_version'])
      end

      def valid_datetime?(value)
        Time.iso8601(value)
        true
      rescue ArgumentError
        false
      end
    end
  end
end
