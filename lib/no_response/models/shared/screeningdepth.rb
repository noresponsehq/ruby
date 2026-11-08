# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ScreeningDepth
        include ::Crystalline::Enum
        enums do
          STANDARD = new("standard")
        end

        open!
      end
    end
  end
end
