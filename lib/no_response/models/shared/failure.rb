# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Failure - Why the attempt failed: the URL is no longer valid, the host did not resolve, it resolved to an address that is not public, no answer within 5 seconds, the connection failed, a 3xx (redirects are not followed) or another non-2xx status. Absent for a delivered attempt.
      class Failure
        include ::Crystalline::Enum
        enums do
          INVALID_URL = new("invalid_url")
          RESOLVE_FAILED = new("resolve_failed")
          ADDRESS_REFUSED = new("address_refused")
          TIMEOUT = new("timeout")
          CONNECTION_FAILED = new("connection_failed")
          REDIRECT = new("redirect")
          NON_2XX = new("non_2xx")
        end

        open!
      end
    end
  end
end
