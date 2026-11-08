# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class HighestBand
        include ::Crystalline::Enum
        enums do
          CRITICAL = new("critical")
          HIGH = new("high")
          MODERATE = new("moderate")
          LOW = new("low")
          INFO = new("info")
        end

        open!
      end
    end
  end
end
