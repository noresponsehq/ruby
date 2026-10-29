# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyEvaluationRequest
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
          :candidates,
          Crystalline::Array.new(Models::Shared::Thresholds),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("candidates"), required: true}}
        )

        field(
          :costs,
          Models::Shared::PolicyEvaluationRequestCosts,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("costs"), required: true}}
        )

        field(
          :limits,
          Models::Shared::PolicyEvaluationRequestLimits,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("limits"), required: true}}
        )

        field(
          :label_collection,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("label_collection"), required: true}}
        )

        field(
          :split_seed,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("split_seed"), required: true}}
        )

        sig {
          params(
            expected_policy_version: ::Integer,
            from: ::String,
            to: ::String,
            candidates: T::Array[Models::Shared::Thresholds],
            costs: Models::Shared::PolicyEvaluationRequestCosts,
            limits: Models::Shared::PolicyEvaluationRequestLimits,
            label_collection: ::String,
            split_seed: ::String
          )
            .void
        }
        def initialize(
          expected_policy_version:,
          from:,
          to:,
          candidates:,
          costs:,
          limits:,
          label_collection:,
          split_seed:
        )
          @expected_policy_version = expected_policy_version
          @from = from
          @to = to
          @candidates = candidates
          @costs = costs
          @limits = limits
          @label_collection = label_collection
          @split_seed = split_seed
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @expected_policy_version == other.expected_policy_version
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @candidates == other.candidates
          return false unless @costs == other.costs
          return false unless @limits == other.limits
          return false unless @label_collection == other.label_collection
          return false unless @split_seed == other.split_seed
          true
        end
      end
    end
  end
end
