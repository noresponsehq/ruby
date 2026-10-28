# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AssessmentAggregateMetric
        include ::Crystalline::Enum
        enums do
          COUNT = new("count")
          SCORE_HISTOGRAM = new("score_histogram")
          LATE_FLIPS = new("late_flips")
        end

        open!
      end
    end
  end
end
