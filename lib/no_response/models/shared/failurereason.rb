# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # FailureReason - Why a signal or source did not produce a definite found/not_found. timed_out means the source missed the request deadline; a continuation may still settle it. deferred means the (source, identifier) pair is async-only and was not attempted on the synchronous path; a continuation settles it.
      class FailureReason
        include ::Crystalline::Enum
        enums do
          TIMED_OUT = new("timed_out")
          RATE_LIMITED = new("rate_limited")
          BLOCKED = new("blocked")
          SOURCE_ERROR = new("source_error")
          UNAVAILABLE = new("unavailable")
          DEFERRED = new("deferred")
          INSUFFICIENT_EVIDENCE = new("insufficient_evidence")
        end

        open!
      end
    end
  end
end
