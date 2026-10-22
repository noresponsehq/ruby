# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The 201 answer of POST /v1/webhooks/{endpoint_id}/rotate: the new signing secret, shown once, which signs every delivery from now on, and when the key it replaced stops verifying. Until then a receiver accepts both.
      class WebhookKeyRotation
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque id of the endpoint registration.
        field(
          :endpoint_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint_id"), required: true}}
        )
        # A newly issued signing key with its secret, shown only in this answer. A receiver verifies NR-Webhook-Signature with the secret's UTF-8 bytes as the HMAC-SHA256 key.
        field(
          :signing_secret,
          Models::Shared::SigningSecret,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("signing_secret"), required: true}}
        )
        # The key that signed until this rotation.
        field(
          :previous_key_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("previous_key_id"), required: true}}
        )
        # When the previous key stops verifying: 7 days after the rotation.
        field(
          :previous_key_expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("previous_key_expires_at"), required: true}}
        )

        sig {
          params(
            endpoint_id: ::String,
            signing_secret: Models::Shared::SigningSecret,
            previous_key_id: ::String,
            previous_key_expires_at: ::String
          )
            .void
        }
        def initialize(endpoint_id:, signing_secret:, previous_key_id:, previous_key_expires_at:)
          @endpoint_id = endpoint_id
          @signing_secret = signing_secret
          @previous_key_id = previous_key_id
          @previous_key_expires_at = previous_key_expires_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint_id == other.endpoint_id
          return false unless @signing_secret == other.signing_secret
          return false unless @previous_key_id == other.previous_key_id
          return false unless @previous_key_expires_at == other.previous_key_expires_at
          true
        end
      end
    end
  end
end
