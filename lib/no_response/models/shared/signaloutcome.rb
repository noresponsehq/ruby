# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # SignalOutcome - Per-signal outcome. A source that timed out, was blocked or errored reports blocked, unavailable or inconclusive with a reason and is listed in incomplete_sources; not_found is a definite absence.
      class SignalOutcome
        include ::Crystalline::Enum
        enums do
          FOUND = new("found")
          NOT_FOUND = new("not_found")
          INCONCLUSIVE = new("inconclusive")
          BLOCKED = new("blocked")
          UNAVAILABLE = new("unavailable")
        end

        open!
      end
    end
  end
end
