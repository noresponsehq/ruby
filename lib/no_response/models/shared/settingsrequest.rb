# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Changes only named settings, atomically. Every successful write advances policy_version and retains an immutable settings snapshot. expected_policy_version optionally guards against stale edits; restore always requires it.
      class SettingsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :retention_days,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retention_days")}}
        )
        # Replaces the refused sources; [] refuses none. A change applies to new assessments within a minute.
        field(
          :refused_sources,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::SourceId)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("refused_sources")}}
        )
        # Use account_creation or its deprecated alias signup, not both.
        field(
          :flows,
          Crystalline::Nilable.new(Models::Shared::SettingsRequestFlows),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("flows")}}
        )
        # Compare-and-set guard. A stale version returns 409 policy_version_conflict before any change; every settings write including retention advances the version.
        field(
          :expected_policy_version,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_policy_version")}}
        )

        field(
          :change_reason,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("change_reason")}}
        )

        sig {
          params(
            retention_days: T.nilable(::Integer),
            refused_sources: T.nilable(T::Array[Models::Shared::SourceId]),
            flows: T.nilable(Models::Shared::SettingsRequestFlows),
            expected_policy_version: T.nilable(::Integer),
            change_reason: T.nilable(::String)
          )
            .void
        }
        def initialize(
          retention_days: nil,
          refused_sources: nil,
          flows: nil,
          expected_policy_version: nil,
          change_reason: nil
        )
          @retention_days = retention_days
          @refused_sources = refused_sources
          @flows = flows
          @expected_policy_version = expected_policy_version
          @change_reason = change_reason
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @retention_days == other.retention_days
          return false unless @refused_sources == other.refused_sources
          return false unless @flows == other.flows
          return false unless @expected_policy_version == other.expected_policy_version
          return false unless @change_reason == other.change_reason
          true
        end
      end
    end
  end
end
