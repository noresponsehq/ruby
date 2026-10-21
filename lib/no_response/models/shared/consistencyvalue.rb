# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ConsistencyValue - How a submitted identifier agrees with what the evidence holds for the other identifiers. unknown is a definite 'cannot tell' (for example a truncated or too-common breach result); absent means the comparison was not made.
      class ConsistencyValue
        include ::Crystalline::Enum
        enums do
          MATCH = new("match")
          PARTIAL = new("partial")
          MISMATCH = new("mismatch")
          UNKNOWN = new("unknown")
        end

        open!
      end
    end
  end
end
