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
        end

        open!
      end
    end
  end
end
