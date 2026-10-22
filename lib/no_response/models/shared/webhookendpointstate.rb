# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # WebhookEndpointState - unverified until the endpoint echoes an endpoint.verification challenge (send one with POST /v1/webhooks/{endpoint_id}/test); verified receives assessment.updated events; disabled after 72 hours of continuous delivery failure, and verified again by the same challenge.
      class WebhookEndpointState
        include ::Crystalline::Enum
        enums do
          UNVERIFIED = new("unverified")
          VERIFIED = new("verified")
          DISABLED = new("disabled")
        end

        open!
      end
    end
  end
end
