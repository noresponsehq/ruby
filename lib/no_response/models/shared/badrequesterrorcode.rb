# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # BadRequestErrorCode - Machine codes an HTTP 400 answer can carry.
      class BadRequestErrorCode
        include ::Crystalline::Enum
        enums do
          INVALID_REQUEST = new("invalid_request")
          INVALID_IDEMPOTENCY_KEY = new("invalid_idempotency_key")
          INVALID_CURSOR = new("invalid_cursor")
          WEBHOOK_URL_REFUSED = new("webhook_url_refused")
        end

        open!
      end
    end
  end
end
