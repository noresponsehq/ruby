# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/webhooks/{endpoint_id}/test body: which event to send.
      class WebhookTestRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # endpoint.verification sends a fresh challenge now, in this call, and the endpoint is verified if it echoes it. assessment.updated queues an event whose data is a fixed example assessment, with test true, delivered and retried like any other; the endpoint must be verified.
        field(
          :event,
          Models::Shared::WebhookTestRequestEvent,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("event"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::WebhookTestRequestEvent, false)
            }
          }
        )

        sig { params(event: Models::Shared::WebhookTestRequestEvent).void }
        def initialize(event:)
          @event = event
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @event == other.event
          true
        end
      end
    end
  end
end
