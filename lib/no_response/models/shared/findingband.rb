# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # FindingBand - How severe a finding is, most severe first.
      class FindingBand
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
