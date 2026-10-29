# typed: true
# frozen_string_literal: true

require "json"
require "openssl"

module NoResponse
  # Verifies webhook deliveries and parses them into typed events.
  module WebhookVerification
    extend T::Sig

    # How far the NR-Webhook-Timestamp header may be from the receiver's clock, in seconds.
    DEFAULT_TOLERANCE_SECONDS = 300

    # Raised by construct_event for a delivery that must not be processed:
    # answer the delivery with a 400 and do not process it. code is one of
    # "missing_header", "duplicate_header", "invalid_timestamp", "unknown_key",
    # "invalid_signature" or "invalid_payload".
    class VerificationError < StandardError
      extend T::Sig

      sig { returns(String) }
      attr_reader :code

      sig { params(code: String, message: String).void }
      def initialize(code, message)
        super("webhook verification failed: #{message} (#{code})")
        @code = code
      end
    end

    HEADER_NAMES = [
      "NR-Webhook-Id",
      "NR-Webhook-Timestamp",
      "NR-Webhook-Key-Id",
      "NR-Webhook-Signature"
    ].freeze
    private_constant :HEADER_NAMES
    EVENT_TYPE = Crystalline::DiscriminatedUnion.new(
      "type",
      {
        "assessment.updated" => Models::Shared::AssessmentUpdatedEvent,
        "endpoint.verification" => Models::Shared::EndpointVerificationEvent,
        "account.deleted" => Models::Shared::AccountDeletedEvent,
        "workspace.deleted" => Models::Shared::WorkspaceDeletedEvent,
        "webhook_endpoint.disabled" => Models::Shared::WebhookEndpointDisabledEvent,
        "account.risk_changed" => Models::Shared::AccountRiskChangedEvent,
        "audit.event" => Models::Shared::AuditEventEvent
      }
    )
    private_constant :EVENT_TYPE

    class << self
      extend T::Sig

      # Verifies a webhook delivery and parses its body.
      #
      # payload is the raw request body exactly as received: re-encoding parsed JSON breaks the signature.
      # headers is a Hash, or an Array of name/value pairs, whose values are Strings or Arrays of Strings.
      # A header repeated in any letter case, or sent as a comma-joined list, is refused.
      # secrets maps each key id, sent in NR-Webhook-Key-Id, to its secret, so a receiver can hold two during a rotation.
      # now is the receiver's clock (a Time or Unix seconds) used for the tolerance check.
      sig do
        params(
          payload: String,
          headers: T::Enumerable[T.untyped],
          secrets: T::Hash[String, String],
          tolerance_seconds: Integer,
          now: T.nilable(T.any(Time, Integer))
        )
          .returns(
            T.any(
              Models::Shared::AssessmentUpdatedEvent,
              Models::Shared::EndpointVerificationEvent,
              Models::Shared::AccountDeletedEvent,
              Models::Shared::WorkspaceDeletedEvent,
              Models::Shared::WebhookEndpointDisabledEvent,
              Models::Shared::AccountRiskChangedEvent,
              Models::Shared::AuditEventEvent
            )
          )
      end
      def construct_event(payload, headers, secrets, tolerance_seconds: DEFAULT_TOLERANCE_SECONDS, now: nil)
        raw = payload.b
        values = header_values(headers)
        id = values.fetch("NR-Webhook-Id")
        timestamp = values.fetch("NR-Webhook-Timestamp")
        key_id = values.fetch("NR-Webhook-Key-Id")
        signature = values.fetch("NR-Webhook-Signature")

        unless timestamp.match?(/\A[0-9]{1,12}\z/)
          raise VerificationError.new("invalid_timestamp", "NR-Webhook-Timestamp is not a Unix time in seconds")
        end

        if ((now || Time.now).to_i - timestamp.to_i).abs > tolerance_seconds
          raise VerificationError.new("invalid_timestamp", "NR-Webhook-Timestamp is outside the tolerance")
        end

        unless secrets.key?(key_id)
          raise VerificationError.new("unknown_key", "NR-Webhook-Key-Id names a key this receiver does not hold")
        end

        secret = secrets.fetch(key_id)
        raise VerificationError.new("invalid_signature", "the webhook secret is empty") if secret.empty?

        received = decode_signature(signature)
        substitutions = {"{timestamp}" => timestamp, "{id}" => id}
        signed = "{timestamp}.".gsub(/\{(?:timestamp|id)\}/, substitutions).b + raw
        expected = OpenSSL::HMAC.digest("SHA256", secret, signed)
        unless received.bytesize == expected.bytesize && OpenSSL.fixed_length_secure_compare(expected, received)
          raise VerificationError.new("invalid_signature", "NR-Webhook-Signature does not match")
        end

        body = begin
          JSON.parse(raw)
        rescue JSON::ParserError, EncodingError
          raise VerificationError.new("invalid_payload", "the body is not JSON")
        end

        unless body.is_a?(::Hash) && body["id"].is_a?(::String) && body["id"] == id
          raise VerificationError.new("invalid_payload", "the body's id does not equal NR-Webhook-Id")
        end

        event = begin
          Crystalline.unmarshal_json(body, EVENT_TYPE)
        rescue StandardError
          nil
        end

        if event.nil? || Crystalline.unknown?(event)
          raise VerificationError.new("invalid_payload", "the body is not a known webhook event")
        end

        event
      end

      private

      sig { params(headers: T::Enumerable[T.untyped]).returns(T::Hash[String, String]) }
      def header_values(headers)
        HEADER_NAMES.to_h do |name|
          found = T.let([], T::Array[String])
          headers.each do |key, value|
            found.concat(Array(value).map(&:to_s)) if key.to_s.casecmp?(name)
          end

          if found.length > 1 || found.first&.include?(",")
            raise VerificationError.new("duplicate_header", "#{name} is repeated")
          end

          raise VerificationError.new("missing_header", "#{name} is missing") if found.first.to_s.empty?

          [name, found.first.to_s]
        end
      end

      sig { params(signature: String).returns(String) }
      def decode_signature(signature)
        encoded = signature.delete_prefix("v1=")
        if encoded.length == signature.length
          raise VerificationError.new("invalid_signature", "NR-Webhook-Signature is malformed")
        end

        unless encoded.match?(/\A(?:[0-9a-fA-F]{2})*\z/)
          raise VerificationError.new("invalid_signature", "NR-Webhook-Signature is malformed")
        end

        [encoded].pack("H*")
      end
    end
  end
end
