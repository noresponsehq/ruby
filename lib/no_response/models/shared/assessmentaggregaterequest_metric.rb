# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AssessmentAggregateRequestMetric < T::Enum
        enums do
          COUNT = new("count")
          SCORE_HISTOGRAM = new("score_histogram")
          SCORE_OUTCOMES = new("score_outcomes")
          LATE_FLIPS = new("late_flips")
        end
      end
    end
  end
end
