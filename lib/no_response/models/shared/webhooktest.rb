# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The 202 answer of POST /v1/webhooks/{endpoint_id}/test: the event that was sent or queued.
      class WebhookTest
        extend T::Sig
        include Crystalline::MetadataFields

        # The event id the receiver sees as NR-Webhook-Id and as the body's id.
        field(
          :delivery_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("delivery_id"), required: true}}
        )
        # Opaque id of the endpoint registration.
        field(
          :endpoint_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint_id"), required: true}}
        )
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
        # unverified until the endpoint echoes an endpoint.verification challenge (send one with POST /v1/webhooks/{endpoint_id}/test); verified receives assessment.updated events; disabled after 72 hours of continuous delivery failure, and verified again by the same challenge.
        field(
          :state,
          Models::Shared::WebhookEndpointState,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("state"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::WebhookEndpointState, false)
            }
          }
        )
        # endpoint.verification only: true when the endpoint echoed the challenge within 5 seconds. A false answer leaves the endpoint's state as it was.
        field(
          :verified,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("verified")}}
        )

        sig {
          params(
            delivery_id: ::String,
            endpoint_id: ::String,
            event: Models::Shared::WebhookTestRequestEvent,
            state: Models::Shared::WebhookEndpointState,
            verified: T.nilable(T::Boolean)
          )
            .void
        }
        def initialize(delivery_id:, endpoint_id:, event:, state:, verified: nil)
          @delivery_id = delivery_id
          @endpoint_id = endpoint_id
          @event = event
          @state = state
          @verified = verified
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @delivery_id == other.delivery_id
          return false unless @endpoint_id == other.endpoint_id
          return false unless @event == other.event
          return false unless @state == other.state
          return false unless @verified == other.verified
          true
        end
      end
    end
  end
end
