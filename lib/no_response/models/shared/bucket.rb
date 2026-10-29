# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Bucket - The period each count covers: an hour, or a day or a week (from Monday) in time_zone. Hour buckets are whole UTC hours in any time zone.
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
