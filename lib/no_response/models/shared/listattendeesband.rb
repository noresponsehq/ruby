# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ListAttendeesBand < T::Enum
        enums do
          CRITICAL = new("critical")
          HIGH = new("high")
          MODERATE = new("moderate")
          LOW = new("low")
          INFO = new("info")
          NONE = new("none")
        end
      end
    end
  end
end
