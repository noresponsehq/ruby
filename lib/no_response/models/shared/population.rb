# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Population - first_answers uses anonymous counters that can include erased detail. retained_first_answers computes exact intersections over retained first answers within 31 days. Requests exceeding the 100000-record work budget are refused.
      class Population
        include ::Crystalline::Enum
        enums do
          FIRST_ANSWERS = new("first_answers")
          RETAINED_FIRST_ANSWERS = new("retained_first_answers")
        end

        open!
      end
    end
  end
end
