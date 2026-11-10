# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # An attendee of another event in the same environment who shares an email or phone with this one, as that event recorded them.
      class OtherEvent
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :event_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_id"), required: true}}
        )

        field(
          :event_name,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_name"), required: true}}
        )

        field(
          :event_starts_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_starts_at"), required: true}}
        )
        # The attendee on that event's list.
        field(
          :attendee_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendee_id"), required: true}}
        )
        # Which identifiers match, in this order. external_id appears only beside email or phone: the same external id alone is not a match, since ticket numbers may be reused across events.
        field(
          :matched_on,
          Crystalline::Array.new(Models::Shared::MatchedOn),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("matched_on"), required: true}}
        )
        # How sure the latest screening is that it found the attendee's accounts. unscreened until a screening reaches the attendee.
        field(
          :match_state,
          Models::Shared::MatchState,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("match_state"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::MatchState, false)
            }
          }
        )
        # That attendee's most severe band at that event, or null.
        field(
          :highest_band,
          Crystalline::Nilable.new(Models::Shared::HighestBand),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("highest_band"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::HighestBand, false)
            }
          }
        )
        # The latest reviewer decision at that event, or null before any.
        field(
          :decision,
          Crystalline::Nilable.new(Models::Shared::AttendeeDecision),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AttendeeDecision, false)
            }
          }
        )
        # Who made that decision.
        field(
          :decided_by,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decided_by")}}
        )
        # When that decision was made.
        field(
          :decided_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decided_at")}}
        )

        sig {
          params(
            event_id: ::String,
            event_name: ::String,
            event_starts_at: ::String,
            attendee_id: ::String,
            matched_on: T::Array[Models::Shared::MatchedOn],
            match_state: Models::Shared::MatchState,
            highest_band: T.nilable(Models::Shared::HighestBand),
            decision: T.nilable(Models::Shared::AttendeeDecision),
            decided_by: T.nilable(::String),
            decided_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          event_id:,
          event_name:,
          event_starts_at:,
          attendee_id:,
          matched_on:,
          match_state:,
          highest_band: nil,
          decision: nil,
          decided_by: nil,
          decided_at: nil
        )
          @event_id = event_id
          @event_name = event_name
          @event_starts_at = event_starts_at
          @attendee_id = attendee_id
          @matched_on = matched_on
          @match_state = match_state
          @highest_band = highest_band
          @decision = decision
          @decided_by = decided_by
          @decided_at = decided_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @event_id == other.event_id
          return false unless @event_name == other.event_name
          return false unless @event_starts_at == other.event_starts_at
          return false unless @attendee_id == other.attendee_id
          return false unless @matched_on == other.matched_on
          return false unless @match_state == other.match_state
          return false unless @highest_band == other.highest_band
          return false unless @decision == other.decision
          return false unless @decided_by == other.decided_by
          return false unless @decided_at == other.decided_at
          true
        end
      end
    end
  end
end
