# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Agreement
        include ::Crystalline::Enum
        enums do
          MATCH = new("match")
          PARTIAL = new("partial")
          MISMATCH = new("mismatch")
        end

        open!
      end
    end
  end
end
