# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The 201 answer of POST /v1/keys/rotate: the new key, shown once, and when the key that was presented stops working. The new key has the scopes and the environment of the presented key.
      class KeyRotation
        extend T::Sig
        include Crystalline::MetadataFields

        # The new credential, nrk_<mode>_<key id>_<secret>, in the environment of the presented key: nrk_live_ or nrk_test_. It is shown only in this answer; store it now.
        field :key, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("key"), required: true}}
        # The public id of the new key.
        field(
          :key_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("key_id"), required: true}}
        )
        # The scopes of the new key: those of the presented key.
        field(
          :scopes,
          Crystalline::Array.new(Models::Shared::KeyRotationScope),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("scopes"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # The id of the key that signed this request.
        field(
          :previous_key_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("previous_key_id"), required: true}}
        )
        # When the previous key stops authenticating. Until then both keys work.
        field(
          :previous_key_expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("previous_key_expires_at"), required: true}}
        )

        sig {
          params(
            key: ::String,
            key_id: ::String,
            scopes: T::Array[Models::Shared::KeyRotationScope],
            created_at: ::String,
            previous_key_id: ::String,
            previous_key_expires_at: ::String
          )
            .void
        }
        def initialize(key:, key_id:, scopes:, created_at:, previous_key_id:, previous_key_expires_at:)
          @key = key
          @key_id = key_id
          @scopes = scopes
          @created_at = created_at
          @previous_key_id = previous_key_id
          @previous_key_expires_at = previous_key_expires_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @key == other.key
          return false unless @key_id == other.key_id
          return false unless @scopes == other.scopes
          return false unless @created_at == other.created_at
          return false unless @previous_key_id == other.previous_key_id
          return false unless @previous_key_expires_at == other.previous_key_expires_at
          true
        end
      end
    end
  end
end
