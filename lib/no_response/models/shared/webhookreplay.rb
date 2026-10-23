# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The 202 answer of POST /v1/webhooks/{endpoint_id}/deliveries/{event_id}/replay: the event queued to be sent again.
      class WebhookReplay
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque id of the endpoint registration.
        field(
          :endpoint_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint_id"), required: true}}
        )
        # The replayed event's id. The receiver sees the same id and body as the first time, with a new NR-Webhook-Timestamp and signature.
        field(
          :event_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_id"), required: true}}
        )
        # The event's type, as its body's type: assessment.updated, account.deleted or account.risk_changed.
        field(
          :event_type,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_type"), required: true}}
        )

        sig { params(endpoint_id: ::String, event_id: ::String, event_type: ::String).void }
        def initialize(endpoint_id:, event_id:, event_type:)
          @endpoint_id = endpoint_id
          @event_id = event_id
          @event_type = event_type
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint_id == other.endpoint_id
          return false unless @event_id == other.event_id
          return false unless @event_type == other.event_type
          true
        end
      end
    end
  end
end
