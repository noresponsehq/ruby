# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # WebhookTestRequestEvent - endpoint.verification sends a fresh challenge now, in this call, and the endpoint is verified if it echoes it. assessment.updated queues an event whose data is a fixed example assessment, with test true, delivered and retried like any other; the endpoint must be verified.
      class WebhookTestRequestEvent
        include ::Crystalline::Enum
        enums do
          ENDPOINT_VERIFICATION = new("endpoint.verification")
          ASSESSMENT_UPDATED = new("assessment.updated")
        end

        open!
      end
    end
  end
end
