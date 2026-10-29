# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # RateLimitErrorCode - Machine codes an HTTP 429 answer can carry.
      class RateLimitErrorCode
        include ::Crystalline::Enum
        enums do
          RATE_LIMITED = new("rate_limited")
          ASSESSMENT_BUDGET_EXHAUSTED = new("assessment_budget_exhausted")
          EXPORT_LIMIT_REACHED = new("export_limit_reached")
        end

        open!
      end
    end
  end
end
