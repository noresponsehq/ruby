# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AccountDecision - block when the score reached your block threshold (risk.block of the assessment), otherwise the assessment's recommendation. held only for a flow whose admission is held (settings flows.<flow>.admission), when the account's current assessment was made for that flow and its investigation has not completed (status partial): the final decision arrives as account.risk_changed when the investigation completes, decided by its score, or when the hold's deadline (hold_seconds after the assessment was created) passes first, as the flow's on_expiry action or the decision the evidence so far gives, whichever is stricter. Your application applies it.
      class AccountDecision
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
