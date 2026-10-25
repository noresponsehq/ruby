# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # OnExpiry - The decision a held assessment takes when hold_seconds pass before its investigation completes, unless the evidence so far gives a stricter one (default review). It is announced as account.risk_changed like any other change, so an expired hold is always announced. A hosted provider hook, which cannot wait, answers a held account by it at once: deny for block, allow otherwise. Kept while the flow is immediate.
      class OnExpiry
        include ::Crystalline::Enum
        enums do
          ALLOW = new("allow")
          REVIEW = new("review")
          BLOCK = new("block")
        end

        open!
      end
    end
  end
end
