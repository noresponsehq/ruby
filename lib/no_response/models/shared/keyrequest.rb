# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/workspaces/{workspace_id}/keys body. Creates an API key in one environment of the workspace with the scopes named, and returns its secret once. A live key needs the admin or owner role; a test key needs developer or above. An API key with the management scope creates keys in its own environment with scopes it holds itself. Each scope may appear once.
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

        sig {
          params(environment: Models::Shared::KeyEnvironment, scopes: T::Array[Models::Shared::KeyRequestScope]).void
        }
        def initialize(environment:, scopes:)
          @environment = environment
          @scopes = scopes
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @environment == other.environment
          return false unless @scopes == other.scopes
          true
        end
      end
    end
  end
end
