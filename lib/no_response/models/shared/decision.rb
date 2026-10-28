# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Decision - The decision of the assessment's latest stored revision: block when its stored risk.block is true, otherwise its recommendation. This is not the account's current decision or held-admission state. Combined with recommendation using AND.
      class Decision < T::Enum
        enums do
          ALLOW = new("allow")
          STEP_UP = new("step_up")
          REVIEW = new("review")
          BLOCK = new("block")
        end
      end
    end
  end
end
