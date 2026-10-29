# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class From
        include ::Crystalline::Enum
        enums do
          ALLOW = new("allow")
          STEP_UP = new("step_up")
          REVIEW = new("review")
          BLOCK = new("block")
          HELD = new("held")
        end

        open!
      end
    end
  end
end
