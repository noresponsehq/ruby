# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The 200 answer of GET /v1/webhooks/{endpoint_id}/deliveries: one page of the endpoint's delivery attempts, newest first. Each item is one POST to the endpoint. Attempts are kept for 30 days, or the workspace's retention_days when that is shorter, and are deleted with the assessment they carried. next_cursor is present only when another page exists.
      class WebhookDeliveryList
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque id of the endpoint registration.
        field(
          :endpoint_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint_id"), required: true}}
        )

        field(
          :items,
          Crystalline::Array.new(Models::Shared::WebhookDeliveryAttempt),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )
        # Opaque cursor for the next page, MAC'd by the server and bound to the workspace and endpoint it was issued for. Pass it back unchanged as cursor; a tampered, foreign or expired cursor answers 400 invalid_cursor.
        field(
          :next_cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_cursor")}}
        )

        sig {
          params(
            endpoint_id: ::String,
            items: T::Array[Models::Shared::WebhookDeliveryAttempt],
            next_cursor: T.nilable(::String)
          )
            .void
        }
        def initialize(endpoint_id:, items:, next_cursor: nil)
          @endpoint_id = endpoint_id
          @items = items
          @next_cursor = next_cursor
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint_id == other.endpoint_id
          return false unless @items == other.items
          return false unless @next_cursor == other.next_cursor
          true
        end
      end
    end
  end
end
