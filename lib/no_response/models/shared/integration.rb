# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A hosted provider integration. Point the provider at url: a WorkOS user registration or authentication Action, or the NoResponse Auth0 Action, which sends secret as a bearer token. The answer allows or denies the event: deny only when the assessment's risk.block is true, and allow on every failure, so a fault on the NoResponse side lets the user through. secret is present only in the answers of POST /v1/integrations and POST /v1/integrations/{integration_id}/rotate for an Auth0 integration, and is not returned again.
      class Integration
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned integration id: int_ and a 26-character Crockford base32 ULID. Another workspace's integration id answers 404.
        field(
          :integration_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("integration_id"), required: true}}
        )
        # The authentication provider that calls the endpoint.
        field(
          :platform,
          Models::Shared::IntegrationPlatform,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("platform"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::IntegrationPlatform, false)
            }
          }
        )
        # Each hook point at most once.
        field(
          :hook_points,
          Crystalline::Array.new(Models::Shared::IntegrationHookPoint),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("hook_points"), required: true}}
        )
        # The hosted endpoint, https://api.noresponse.org/hooks/{integration_id} in production.
        field :url, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("url"), required: true}}

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # Auth0 only, and only when it is created or rotated: the shared secret the Auth0 Action sends as Authorization: Bearer <secret>. nri_ and 43 unpadded base64url characters (32 random bytes). Store it as an Auth0 Action secret.
        field(
          :secret,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("secret")}}
        )
        # When the secret was last rotated; absent until the first rotation.
        field(
          :rotated_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("rotated_at")}}
        )
        # After a rotation, when the replaced secret stops being accepted; absent when no replaced secret is still accepted.
        field(
          :previous_secret_expires_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("previous_secret_expires_at")}}
        )

        sig {
          params(
            integration_id: ::String,
            platform: Models::Shared::IntegrationPlatform,
            hook_points: T::Array[Models::Shared::IntegrationHookPoint],
            url: ::String,
            created_at: ::String,
            secret: T.nilable(::String),
            rotated_at: T.nilable(::String),
            previous_secret_expires_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          integration_id:,
          platform:,
          hook_points:,
          url:,
          created_at:,
          secret: nil,
          rotated_at: nil,
          previous_secret_expires_at: nil
        )
          @integration_id = integration_id
          @platform = platform
          @hook_points = hook_points
          @url = url
          @created_at = created_at
          @secret = secret
          @rotated_at = rotated_at
          @previous_secret_expires_at = previous_secret_expires_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @integration_id == other.integration_id
          return false unless @platform == other.platform
          return false unless @hook_points == other.hook_points
          return false unless @url == other.url
          return false unless @created_at == other.created_at
          return false unless @secret == other.secret
          return false unless @rotated_at == other.rotated_at
          return false unless @previous_secret_expires_at == other.previous_secret_expires_at
          true
        end
      end
    end
  end
end
