# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Delay - How long after the assessment's creation the change was made.
      class Delay
        include ::Crystalline::Enum
        enums do
          UNDER_10S = new("under_10s")
          UNDER_1M = new("under_1m")
          UNDER_10M = new("under_10m")
          UNDER_1H = new("under_1h")
          UNDER_1D = new("under_1d")
          OVER_1D = new("over_1d")
        end

        open!
      end
    end
  end
end
