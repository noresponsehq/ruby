# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Reviews created in [from,to) whose review and current account assessment remain retained. Status and assignment are current at as_of, not a transition history. label_coverage numerator is resolved reviews labeled benign or abuse; denominator is resolved reviews. Inconclusive is not a known outcome. Review conclusions do not change account feedback or enforcement.
      class Reviews
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :denominator,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("denominator"), required: true}}
        )

        field :open, ::Integer, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("open"), required: true}}

        field(
          :in_progress,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("in_progress"), required: true}}
        )

        field(
          :resolved,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("resolved"), required: true}}
        )

        field(
          :assigned,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assigned"), required: true}}
        )

        field(
          :unassigned,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unassigned"), required: true}}
        )
        # Counts only; a zero denominator means no eligible retained records and does not imply a zero rate.
        field(
          :label_coverage,
          Models::Shared::Coverage,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("label_coverage"), required: true}}
        )
        # Current resolution of each resolved retained review; prior resolutions and reopened reviews do not count. Missing keys mean zero. These investigation conclusions are independent of account feedback.
        field(
          :conclusions,
          Models::Shared::ReviewsConclusions,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("conclusions"), required: true}}
        )

        field(
          :population,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("population"), required: true}}
        )

        sig {
          params(
            denominator: ::Integer,
            open: ::Integer,
            in_progress: ::Integer,
            resolved: ::Integer,
            assigned: ::Integer,
            unassigned: ::Integer,
            label_coverage: Models::Shared::Coverage,
            conclusions: Models::Shared::ReviewsConclusions,
            population: ::String
          )
            .void
        }
        def initialize(
          denominator:,
          open:,
          in_progress:,
          resolved:,
          assigned:,
          unassigned:,
          label_coverage:,
          conclusions:,
          population: "retained_reviews_by_created_at"
        )
          @denominator = denominator
          @open = open
          @in_progress = in_progress
          @resolved = resolved
          @assigned = assigned
          @unassigned = unassigned
          @label_coverage = label_coverage
          @conclusions = conclusions
          unless population == "retained_reviews_by_created_at"
            raise ArgumentError, "Invalid value for population"
          end

          @population = "retained_reviews_by_created_at"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @denominator == other.denominator
          return false unless @open == other.open
          return false unless @in_progress == other.in_progress
          return false unless @resolved == other.resolved
          return false unless @assigned == other.assigned
          return false unless @unassigned == other.unassigned
          return false unless @label_coverage == other.label_coverage
          return false unless @conclusions == other.conclusions
          return false unless @population == other.population
          true
        end
      end
    end
  end
end
