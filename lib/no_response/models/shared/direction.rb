# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Direction
        include ::Crystalline::Enum
        enums do
          RAISES = new("raises")
          LOWERS = new("lowers")
          NEUTRAL = new("neutral")
        end

        open!
      end
    end
  end
end
