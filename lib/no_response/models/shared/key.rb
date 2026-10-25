# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One API key of your workspace. A key belongs to exactly one environment. key, the secret credential, is present only in the answer that created the key: NoResponse keeps a peppered digest of it, so store it now. Every other field is safe to show.
      class Key
        extend T::Sig
        include Crystalline::MetadataFields

        # The key's public id, a 26-character ULID.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # The workspace id, which is also its live environment's workspace id; the test environment's is the same id with :test appended. A workspace created through the API is tnt_ and a 26-character ULID.
        field(
          :workspace_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("workspace_id"), required: true}}
        )
        # The environment the key belongs to. A live key assesses with live sources; a test key answers from the deterministic simulator.
        field(
          :environment,
          Models::Shared::KeyEnvironment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::KeyEnvironment, false)
            }
          }
        )
        # The public start of the credential, nrk_<environment>_<key id>, which identifies the key in logs and secret stores without its secret.
        field(
          :prefix,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("prefix"), required: true}}
        )
        # The key's scopes, each at most once.
        field(
          :scopes,
          Crystalline::Array.new(Models::Shared::KeyScope),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("scopes"), required: true}}
        )
        # active: the key authenticates. expired: a rotation's overlap window has ended (expires_at). revoked: the key was revoked (revoked_at) and answers 401.
        field(
          :status,
          Models::Shared::KeyStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::KeyStatus, false)
            }
          }
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # The external user id of the member who created the key through the console, or the prefix (nrk_<environment>_<key id>) of the management key that created it. Absent for a key NoResponse issued or a rotation made.
        field(
          :created_by,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_by")}}
        )
        # When a rotated key stops authenticating (POST /v1/keys/rotate). Absent for a key with no end.
        field(
          :expires_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at")}}
        )

        field(
          :revoked_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("revoked_at")}}
        )
        # The external user id of the member who revoked the key through the console, or the prefix of the management key that revoked it. Absent when the key is not revoked or NoResponse revoked it.
        field(
          :revoked_by,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("revoked_by")}}
        )
        # The credential, nrk_<environment>_<key id>_<secret>. Present only in the 201 answer that created the key.
        field(
          :key,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("key")}}
        )

        sig {
          params(
            id: ::String,
            workspace_id: ::String,
            environment: Models::Shared::KeyEnvironment,
            prefix: ::String,
            scopes: T::Array[Models::Shared::KeyScope],
            status: Models::Shared::KeyStatus,
            created_at: ::String,
            created_by: T.nilable(::String),
            expires_at: T.nilable(::String),
            revoked_at: T.nilable(::String),
            revoked_by: T.nilable(::String),
            key: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          workspace_id:,
          environment:,
          prefix:,
          scopes:,
          status:,
          created_at:,
          created_by: nil,
          expires_at: nil,
          revoked_at: nil,
          revoked_by: nil,
          key: nil
        )
          @id = id
          @workspace_id = workspace_id
          @environment = environment
          @prefix = prefix
          @scopes = scopes
          @status = status
          @created_at = created_at
          @created_by = created_by
          @expires_at = expires_at
          @revoked_at = revoked_at
          @revoked_by = revoked_by
          @key = key
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @prefix == other.prefix
          return false unless @scopes == other.scopes
          return false unless @status == other.status
          return false unless @created_at == other.created_at
          return false unless @created_by == other.created_by
          return false unless @expires_at == other.expires_at
          return false unless @revoked_at == other.revoked_at
          return false unless @revoked_by == other.revoked_by
          return false unless @key == other.key
          true
        end
      end
    end
  end
end
