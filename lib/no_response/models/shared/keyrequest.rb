# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Creates a key whose scopes are bounded by the issuer capabilities in this environment. Delete is owner-only. A service key outlives its creator; a personal key belongs to the authenticated member and is revoked on membership or authority changes. request_id deduplicates creation: retry returns 200 metadata without the secret; changed parameters answer 409. Team scopes members and members_manage are explicitly workspace-wide, live-only, and delegated by a current full owner. Personal credentials cannot hold management or members_manage. Legacy management includes policy publication; use settings without policy_publish for configuration preparation and retention-only edits.
      class KeyRequest
        extend T::Sig
        include Crystalline::MetadataFields

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
        # The key's scopes, each at most once.
        field(
          :scopes,
          Crystalline::Array.new(Models::Shared::KeyRequestScope),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("scopes"), required: true}}
        )
        # Optional display name for this API key, at most 100 printable characters. Preserved on rotation.
        field(
          :name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name")}}
        )
        # Optional operational purpose, at most 200 printable characters without leading or trailing whitespace. Do not put secrets or personal data here. Preserved on rotation and included in the creation request fingerprint; omitted for older credentials.
        field(
          :purpose,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("purpose")}}
        )

        field(
          :kind,
          Crystalline::Nilable.new(Models::Shared::KeyKind),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::KeyKind, true)
            }
          }
        )
        # Between one minute and 365 days from now.
        field(
          :expires_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at")}}
        )
        # Caller-chosen identifier for one creation attempt, scoped to the issuing actor and environment. Use 1 to 256 printable ASCII characters without spaces. A retry with the same parameters returns the original key metadata with status 200 and no secret; changed parameters return 409.
        field(
          :request_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("request_id")}}
        )

        sig {
          params(
            environment: Models::Shared::KeyEnvironment,
            scopes: T::Array[Models::Shared::KeyRequestScope],
            name: T.nilable(::String),
            purpose: T.nilable(::String),
            kind: T.nilable(Models::Shared::KeyKind),
            expires_at: T.nilable(::String),
            request_id: T.nilable(::String)
          )
            .void
        }
        def initialize(environment:, scopes:, name: nil, purpose: nil, kind: nil, expires_at: nil, request_id: nil)
          @environment = environment
          @scopes = scopes
          @name = name
          @purpose = purpose
          @kind = kind
          @expires_at = expires_at
          @request_id = request_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @environment == other.environment
          return false unless @scopes == other.scopes
          return false unless @name == other.name
          return false unless @purpose == other.purpose
          return false unless @kind == other.kind
          return false unless @expires_at == other.expires_at
          return false unless @request_id == other.request_id
          true
        end
      end
    end
  end
end
