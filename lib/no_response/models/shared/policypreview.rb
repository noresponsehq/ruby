# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Exact threshold transitions among eligible retained first answers, newest first within the limit. Partial older revisions without a frozen hold snapshot are reported as unsupported. Preview leaves account state, outcomes and source evidence unchanged.
      class PolicyPreview
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :policy_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("policy_version"), required: true}}
        )

        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}

        field :to, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("to"), required: true}}

        field(
          :retention_from,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retention_from"), required: true}}
        )

        field(
          :coverage,
          Models::Shared::PolicyPreviewCoverage,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("coverage"), required: true}}
        )

        field(
          :changed,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("changed"), required: true}}
        )

        field(
          :unchanged,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unchanged"), required: true}}
        )

        field(
          :transitions,
          Crystalline::Array.new(Models::Shared::PolicyPreviewTransition),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("transitions"), required: true}}
        )

        field(
          :scope,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("scope"), required: true}}
        )

        sig {
          params(
            policy_version: ::Integer,
            from: ::String,
            to: ::String,
            retention_from: ::String,
            coverage: Models::Shared::PolicyPreviewCoverage,
            changed: ::Integer,
            unchanged: ::Integer,
            transitions: T::Array[Models::Shared::PolicyPreviewTransition],
            scope: ::String
          )
            .void
        }
        def initialize(
          policy_version:,
          from:,
          to:,
          retention_from:,
          coverage:,
          changed:,
          unchanged:,
          transitions:,
          scope: "retained_first_answer_thresholds"
        )
          @policy_version = policy_version
          @from = from
          @to = to
          @retention_from = retention_from
          @coverage = coverage
          @changed = changed
          @unchanged = unchanged
          @transitions = transitions
          unless scope == "retained_first_answer_thresholds"
            raise ArgumentError, "Invalid value for scope"
          end

          @scope = "retained_first_answer_thresholds"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @policy_version == other.policy_version
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @retention_from == other.retention_from
          return false unless @coverage == other.coverage
          return false unless @changed == other.changed
          return false unless @unchanged == other.unchanged
          return false unless @transitions == other.transitions
          return false unless @scope == other.scope
          true
        end
      end
    end
  end
end
