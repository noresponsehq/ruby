# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AccountDecision - block when the score reached your block threshold (risk.block of the assessment), otherwise the assessment's recommendation. Your application applies it.
      class AccountDecision
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
