# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Confidence - Ordinal confidence in the recommendation under the current policy: low, medium, high or unavailable.
      class Confidence
        include ::Crystalline::Enum
        enums do
          LOW = new("low")
          MEDIUM = new("medium")
          HIGH = new("high")
          UNAVAILABLE = new("unavailable")
        end

        open!
      end
    end
  end
end
