# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One environment's settings: how long its assessments are kept, and for each flow the risk thresholds that decide it and the depth a request that names none is served at, and the sources it refuses. Live and test each have their own. A flow without thresholds of its own uses account_creation's (inherits_account_creation). Every change is recorded in the audit log as settings.updated, with who made it.
      class Settings
        extend T::Sig
        include Crystalline::MetadataFields

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
        # Days an assessment is kept after it is created, 1 to 365 (default 365). Shortening hides older assessments at once.
        field(
          :retention_days,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retention_days"), required: true}}
        )
        # How many times this environment's policy has changed; 0 while the defaults apply. A served risk.policy_version ends in +t<policy_version> once it is above 0.
        field(
          :policy_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("policy_version"), required: true}}
        )

        field(
          :flows,
          Models::Shared::SettingsFlows,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("flows"), required: true}}
        )
        # The sources this environment refuses, sorted; empty, the default, refuses none. An assessment leaves a refused source out: its coverage is missing (an identifier with no other source lists coverage-unavailable as unavailable) rather than not_found, and a stored result of a refused source is not reused.
        field(
          :refused_sources,
          Crystalline::Array.new(Models::Shared::SourceId),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("refused_sources"), required: true}}
        )
        # Who last changed the policy: the member's external user id for a change made through the console, the prefix (nrk_<environment>_<key id>) of the management key that made it, or NoResponse. Absent while the defaults apply.
        field(
          :updated_by,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_by")}}
        )
        # When the policy last changed. Absent while the defaults apply.
        field(
          :updated_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_at")}}
        )

        sig {
          params(
            workspace_id: ::String,
            environment: Models::Shared::KeyEnvironment,
            retention_days: ::Integer,
            policy_version: ::Integer,
            flows: Models::Shared::SettingsFlows,
            refused_sources: T::Array[Models::Shared::SourceId],
            updated_by: T.nilable(::String),
            updated_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          workspace_id:,
          environment:,
          retention_days:,
          policy_version:,
          flows:,
          refused_sources:,
          updated_by: nil,
          updated_at: nil
        )
          @workspace_id = workspace_id
          @environment = environment
          @retention_days = retention_days
          @policy_version = policy_version
          @flows = flows
          @refused_sources = refused_sources
          @updated_by = updated_by
          @updated_at = updated_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @retention_days == other.retention_days
          return false unless @policy_version == other.policy_version
          return false unless @flows == other.flows
          return false unless @refused_sources == other.refused_sources
          return false unless @updated_by == other.updated_by
          return false unless @updated_at == other.updated_at
          true
        end
      end
    end
  end
end
