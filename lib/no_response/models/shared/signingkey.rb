# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One signing key, by id. The secret is not included.
      class SigningKey
        extend T::Sig
        include Crystalline::MetadataFields

        # The signing key id, sent as NR-Webhook-Key-Id on every delivery it signs.
        field(
          :key_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("key_id"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # Present on a key a rotation replaced: it stops verifying at this instant, 7 days after the rotation. Absent on the key that signs.
        field(
          :expires_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at")}}
        )

        sig { params(key_id: ::String, created_at: ::String, expires_at: T.nilable(::String)).void }
        def initialize(key_id:, created_at:, expires_at: nil)
          @key_id = key_id
          @created_at = created_at
          @expires_at = expires_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @key_id == other.key_id
          return false unless @created_at == other.created_at
          return false unless @expires_at == other.expires_at
          true
        end
      end
    end
  end
end
