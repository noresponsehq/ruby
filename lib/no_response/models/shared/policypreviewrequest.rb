# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Side-effect-free threshold preview for at most 31 days. Retained first answers are evaluated at their exact frozen scores using the production threshold and hold rules. Changes to admission, source selection, depth or retention are not simulated.
      class PolicyPreviewRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :expected_policy_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_policy_version"), required: true}}
        )

        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}

        field :to, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("to"), required: true}}

        field(
          :flows,
          Models::Shared::PolicyPreviewRequestFlows,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("flows"), required: true}}
        )

        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("limit")}}
        )

        sig {
          params(
            expected_policy_version: ::Integer,
            from: ::String,
            to: ::String,
            flows: Models::Shared::PolicyPreviewRequestFlows,
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(expected_policy_version:, from:, to:, flows:, limit: 1000)
          @expected_policy_version = expected_policy_version
          @from = from
          @to = to
          @flows = flows
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @expected_policy_version == other.expected_policy_version
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @flows == other.flows
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
