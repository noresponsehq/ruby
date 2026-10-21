# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Status - complete: final; nothing is still running. A lane that failed or missed its 10 s deadline stays listed in incomplete_sources, and confidence is lower. partial: a recommendation exists and at least one lane is still running or did not settle (see incomplete_sources). pending: nothing usable before the deadline; no recommendation yet, poll or wait for the webhook.
      class Status
        include ::Crystalline::Enum
        enums do
          COMPLETE = new("complete")
          PARTIAL = new("partial")
          PENDING = new("pending")
        end

        open!
      end
    end
  end
end
