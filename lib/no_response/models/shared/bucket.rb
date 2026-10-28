# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Bucket - The period each count covers, in UTC; a week starts on Monday.
      class Bucket
        include ::Crystalline::Enum
        enums do
          HOUR = new("hour")
          DAY = new("day")
          WEEK = new("week")
        end

        open!
      end
    end
  end
end
