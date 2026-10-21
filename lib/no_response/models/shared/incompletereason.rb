# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # IncompleteReason - Why a lane did not settle. deferred means the lane is asynchronous and still running; a continuation settles it. timed_out means the lane missed its deadline. insufficient_evidence is a settled inconclusive signal rather than an incomplete lane.
      class IncompleteReason
        include ::Crystalline::Enum
        enums do
          TIMED_OUT = new("timed_out")
          RATE_LIMITED = new("rate_limited")
          BLOCKED = new("blocked")
          SOURCE_ERROR = new("source_error")
          UNAVAILABLE = new("unavailable")
          DEFERRED = new("deferred")
        end

        open!
      end
    end
  end
end
