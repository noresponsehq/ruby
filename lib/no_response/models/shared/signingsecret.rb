# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A newly issued signing key with its secret, shown only in this answer. A receiver verifies NR-Webhook-Signature with the secret's UTF-8 bytes as the HMAC-SHA256 key.
      class SigningSecret
        extend T::Sig
        include Crystalline::MetadataFields

        # The signing key id, sent as NR-Webhook-Key-Id on every delivery it signs.
        field(
          :key_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("key_id"), required: true}}
        )
        # The signing secret: 32 random bytes as 43 characters of unpadded base64url. It is not stored in readable form or returned again.
        field(
          :secret,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("secret"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        sig { params(key_id: ::String, secret: ::String, created_at: ::String).void }
        def initialize(key_id:, secret:, created_at:)
          @key_id = key_id
          @secret = secret
          @created_at = created_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @key_id == other.key_id
          return false unless @secret == other.secret
          return false unless @created_at == other.created_at
          true
        end
      end
    end
  end
end
