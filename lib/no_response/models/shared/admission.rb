# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Admission - immediate (the default): an assessment of this flow is decided from the evidence its answer has, and later evidence may change the decision. held: while the account's current assessment of this flow has not completed, the account's decision for the flow is held, and the final decision arrives as account.risk_changed when the investigation completes or hold_seconds pass, whichever is first. Each flow has its own admission.
      class Admission
        include ::Crystalline::Enum
        enums do
          IMMEDIATE = new("immediate")
          HELD = new("held")
        end

        open!
      end
    end
  end
end
