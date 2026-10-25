# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # PATCH /v1/workspaces/{workspace_id}/settings/{environment} body. Changes only what it names, in one transaction; a policy change is one new policy_version. Needs the admin or owner role, or an API key with the management scope for its own environment.
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

        sig {
          params(
            retention_days: T.nilable(::Integer),
            refused_sources: T.nilable(T::Array[Models::Shared::SourceId]),
            flows: T.nilable(Models::Shared::SettingsRequestFlows)
          )
            .void
        }
        def initialize(retention_days: nil, refused_sources: nil, flows: nil)
          @retention_days = retention_days
          @refused_sources = refused_sources
          @flows = flows
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @retention_days == other.retention_days
          return false unless @refused_sources == other.refused_sources
          return false unless @flows == other.flows
          true
        end
      end
    end
  end
end
