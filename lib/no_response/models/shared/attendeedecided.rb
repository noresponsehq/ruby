# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A reviewer recorded a decision on an attendee. The decision's note stays in the API. Sent once per recorded review; an attendee's latest review is its decision, so order by decided_at.
      class AttendeeDecided
        extend T::Sig
        include Crystalline::MetadataFields

        # The attendee's event.
        field(
          :event_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_id"), required: true}}
        )
        # The attendee decided on.
        field(
          :attendee_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendee_id"), required: true}}
        )
        # The recorded review.
        field(
          :review_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("review_id"), required: true}}
        )

        field(
          :decision,
          Models::Shared::AttendeeDecision,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AttendeeDecision, false)
            }
          }
        )
        # Who decided: the member's external user id, or the API key's label, as the attendee's decided_by.
        field(
          :decided_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decided_by"), required: true}}
        )
        # When the decision was recorded; equal to the event's created_at.
        field(
          :decided_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decided_at"), required: true}}
        )

        sig {
          params(
            event_id: ::String,
            attendee_id: ::String,
            review_id: ::String,
            decision: Models::Shared::AttendeeDecision,
            decided_by: ::String,
            decided_at: ::String
          )
            .void
        }
        def initialize(event_id:, attendee_id:, review_id:, decision:, decided_by:, decided_at:)
          @event_id = event_id
          @attendee_id = attendee_id
          @review_id = review_id
          @decision = decision
          @decided_by = decided_by
          @decided_at = decided_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @event_id == other.event_id
          return false unless @attendee_id == other.attendee_id
          return false unless @review_id == other.review_id
          return false unless @decision == other.decision
          return false unless @decided_by == other.decided_by
          return false unless @decided_at == other.decided_at
          true
        end
      end
    end
  end
end
