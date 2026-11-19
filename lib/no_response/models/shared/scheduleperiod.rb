# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # SchedulePeriod - How often the person is investigated again: daily, weekly or monthly, counted from when the schedule was set; off runs no scheduled investigation.
      class SchedulePeriod
        include ::Crystalline::Enum
        enums do
          DAILY = new("daily")
          WEEKLY = new("weekly")
          MONTHLY = new("monthly")
          OFF = new("off")
        end

        open!
      end
    end
  end
end
