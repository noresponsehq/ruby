# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Captured in the same database snapshot as the counts. Capture start times describe when counting began, not the earliest creation time counted: an older assessment may first answer later. Older outcomes are not inferred to be absent. Erased detail cannot be returned by drill-down even while its anonymous count remains.
      class AssessmentAggregateCoverage
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :as_of,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("as_of"), required: true}}
        )

        field(
          :first_answers_started_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("first_answers_started_at"), required: true}}
        )

        field(
          :score_outcomes_started_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_outcomes_started_at"), required: true}}
        )

        field(
          :retained_from,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retained_from"), required: true}}
        )
        # first_answers uses anonymous counters that can include erased detail. retained_first_answers computes exact intersections over retained first answers within 31 days. Requests exceeding the 100000-record work budget are refused.
        field(
          :population,
          Models::Shared::Population,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("population"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Population, false)
            }
          }
        )

        field(
          :erased_records_included,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("erased_records_included"), required: true}}
        )

        field(
          :overlapping_groups,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("overlapping_groups"), required: true}}
        )

        field(
          :late_flip_unit,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("late_flip_unit"), required: true}}
        )

        field(
          :historical_backfill,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("historical_backfill"), required: true}}
        )

        sig {
          params(
            as_of: ::String,
            first_answers_started_at: ::String,
            score_outcomes_started_at: ::String,
            retained_from: ::String,
            population: Models::Shared::Population,
            erased_records_included: T::Boolean,
            overlapping_groups: T::Boolean,
            late_flip_unit: ::String,
            historical_backfill: T::Boolean
          )
            .void
        }
        def initialize(
          as_of:,
          first_answers_started_at:,
          score_outcomes_started_at:,
          retained_from:,
          population:,
          erased_records_included:,
          overlapping_groups:,
          late_flip_unit: "decision_transitions",
          historical_backfill: false
        )
          @as_of = as_of
          @first_answers_started_at = first_answers_started_at
          @score_outcomes_started_at = score_outcomes_started_at
          @retained_from = retained_from
          @population = population
          @erased_records_included = erased_records_included
          @overlapping_groups = overlapping_groups
          unless late_flip_unit == "decision_transitions"
            raise ArgumentError, "Invalid value for late_flip_unit"
          end

          @late_flip_unit = "decision_transitions"
          unless historical_backfill == false
            raise ArgumentError, "Invalid value for historical_backfill"
          end

          @historical_backfill = false
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @as_of == other.as_of
          return false unless @first_answers_started_at == other.first_answers_started_at
          return false unless @score_outcomes_started_at == other.score_outcomes_started_at
          return false unless @retained_from == other.retained_from
          return false unless @population == other.population
          return false unless @erased_records_included == other.erased_records_included
          return false unless @overlapping_groups == other.overlapping_groups
          return false unless @late_flip_unit == other.late_flip_unit
          return false unless @historical_backfill == other.historical_backfill
          true
        end
      end
    end
  end
end
