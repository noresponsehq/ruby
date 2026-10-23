# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # WebhookDeliveryAttemptStatus - delivered when the endpoint answered 2xx; failed otherwise, with failure naming why.
      class WebhookDeliveryAttemptStatus
        include ::Crystalline::Enum
        enums do
          DELIVERED = new("delivered")
          FAILED = new("failed")
        end

        open!
      end
    end
  end
end
