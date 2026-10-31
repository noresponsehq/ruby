# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class WebhookDeliveryAttempt
        extend T::Sig
        include Crystalline::MetadataFields

        # The event id the receiver saw as NR-Webhook-Id and as the body's id. Replay it with POST /v1/webhooks/{endpoint_id}/deliveries/{event_id}/replay.
        field(
          :event_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_id"), required: true}}
        )
        # The event's type, as its body's type: assessment.updated, endpoint.verification, account.deleted, workspace.deleted, webhook_endpoint.disabled, account.risk_changed, audit.event, or a type added later.
        field(
          :event_type,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_type"), required: true}}
        )
        # Which attempt of this delivery this was: 1 for the first send, up to 9 with retries. A replay counts its own attempts from 1.
        field(
          :attempt,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attempt"), required: true}}
        )
        # true for an attempt of a replay you asked for.
        field(
          :replay,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("replay"), required: true}}
        )
        # delivered when the endpoint answered 2xx; failed otherwise, with failure naming why.
        field(
          :status,
          Models::Shared::WebhookDeliveryAttemptStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::WebhookDeliveryAttemptStatus, false)
            }
          }
        )
        # Milliseconds from sending the request to the answer or the failure.
        field(
          :latency_ms,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("latency_ms"), required: true}}
        )
        # When the request was sent. Its NR-Webhook-Timestamp is this time in Unix seconds.
        field(
          :attempted_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attempted_at"), required: true}}
        )
        # The assessment an assessment.updated event reported, while that assessment is held. Absent on every other event, on a test event and on a notice that the assessment was erased or expired.
        field(
          :assessment_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id")}}
        )
        # The account an account.risk_changed event reported. Absent on every other event.
        field(
          :account_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id")}}
        )
        # The HTTP status the endpoint answered. Absent when no response was read.
        field(
          :response_code,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("response_code")}}
        )
        # Why the attempt failed: the URL is no longer valid, the host did not resolve, it resolved to an address that is not public, no answer within 5 seconds, the connection failed, a 3xx (redirects are not followed) or another non-2xx status. Absent for a delivered attempt.
        field(
          :failure,
          Crystalline::Nilable.new(Models::Shared::Failure),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("failure"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Failure, true)
            }
          }
        )

        sig {
          params(
            event_id: ::String,
            event_type: ::String,
            attempt: ::Integer,
            replay: T::Boolean,
            status: Models::Shared::WebhookDeliveryAttemptStatus,
            latency_ms: ::Integer,
            attempted_at: ::String,
            assessment_id: T.nilable(::String),
            account_id: T.nilable(::String),
            response_code: T.nilable(::Integer),
            failure: T.nilable(Models::Shared::Failure)
          )
            .void
        }
        def initialize(
          event_id:,
          event_type:,
          attempt:,
          replay:,
          status:,
          latency_ms:,
          attempted_at:,
          assessment_id: nil,
          account_id: nil,
          response_code: nil,
          failure: nil
        )
          @event_id = event_id
          @event_type = event_type
          @attempt = attempt
          @replay = replay
          @status = status
          @latency_ms = latency_ms
          @attempted_at = attempted_at
          @assessment_id = assessment_id
          @account_id = account_id
          @response_code = response_code
          @failure = failure
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @event_id == other.event_id
          return false unless @event_type == other.event_type
          return false unless @attempt == other.attempt
          return false unless @replay == other.replay
          return false unless @status == other.status
          return false unless @latency_ms == other.latency_ms
          return false unless @attempted_at == other.attempted_at
          return false unless @assessment_id == other.assessment_id
          return false unless @account_id == other.account_id
          return false unless @response_code == other.response_code
          return false unless @failure == other.failure
          true
        end
      end
    end
  end
end
