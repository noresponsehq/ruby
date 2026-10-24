# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One of the environment's endpoints stopped receiving events: every delivery attempt to it failed from failing_since until disabled_at, 72 hours or more. Its queued deliveries are dropped. Fix the receiver and verify it again with POST /v1/webhooks/{endpoint_id}/test (type endpoint.verification) to resume delivery.
      class WebhookEndpointDisabled
        extend T::Sig
        include Crystalline::MetadataFields

        # The endpoint that was disabled.
        field(
          :endpoint_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint_id"), required: true}}
        )
        # The first failed attempt of the unbroken failure streak.
        field(
          :failing_since,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("failing_since"), required: true}}
        )
        # When the endpoint was disabled; equal to the event's created_at.
        field(
          :disabled_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("disabled_at"), required: true}}
        )

        sig { params(endpoint_id: ::String, failing_since: ::String, disabled_at: ::String).void }
        def initialize(endpoint_id:, failing_since:, disabled_at:)
          @endpoint_id = endpoint_id
          @failing_since = failing_since
          @disabled_at = disabled_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint_id == other.endpoint_id
          return false unless @failing_since == other.failing_since
          return false unless @disabled_at == other.disabled_at
          true
        end
      end
    end
  end
end
