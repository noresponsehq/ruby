# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AggregateBucket
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :start,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("start"), required: true}}
        )
        # Assessments first answered whose creation falls in the bucket. With metric count.
        field(
          :count,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("count")}}
        )
        # With metric count and group_by: the bucket's counts of the groups answered, largest group first.
        field(
          :groups,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::AggregateGroup)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("groups")}}
        )

        field(
          :score_histogram,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::AggregateScoreCount)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_histogram")}}
        )
        # With metric score_outcomes: the score_histogram's first answers whose assessment has a reported outcome, by its latest. A bin's count less its score_outcomes is the first answers with none reported.
        field(
          :score_outcomes,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::AggregateScoreOutcome)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_outcomes")}}
        )

        field(
          :late_flips,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::AggregateLateFlip)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("late_flips")}}
        )

        sig {
          params(
            start: ::String,
            count: T.nilable(::Integer),
            groups: T.nilable(T::Array[Models::Shared::AggregateGroup]),
            score_histogram: T.nilable(T::Array[Models::Shared::AggregateScoreCount]),
            score_outcomes: T.nilable(T::Array[Models::Shared::AggregateScoreOutcome]),
            late_flips: T.nilable(T::Array[Models::Shared::AggregateLateFlip])
          )
            .void
        }
        def initialize(start:, count: nil, groups: nil, score_histogram: nil, score_outcomes: nil, late_flips: nil)
          @start = start
          @count = count
          @groups = groups
          @score_histogram = score_histogram
          @score_outcomes = score_outcomes
          @late_flips = late_flips
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @start == other.start
          return false unless @count == other.count
          return false unless @groups == other.groups
          return false unless @score_histogram == other.score_histogram
          return false unless @score_outcomes == other.score_outcomes
          return false unless @late_flips == other.late_flips
          true
        end
      end
    end
  end
end
