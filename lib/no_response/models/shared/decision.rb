# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Decision - An assessment's own decision: block when its stored risk.block is true, otherwise its recommendation. It is not the account's decision or held-admission state.
      class Decision
        include ::Crystalline::Enum
        enums do
          ALLOW = new("allow")
          STEP_UP = new("step_up")
          REVIEW = new("review")
          BLOCK = new("block")
        end

        open!
      end
    end
  end
end
