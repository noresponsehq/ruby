# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Source
        include ::Crystalline::Enum
        enums do
          REQUESTS = new("requests")
          WEBHOOK_ATTEMPTS = new("webhook_attempts")
        end

        open!
      end
    end
  end
end
