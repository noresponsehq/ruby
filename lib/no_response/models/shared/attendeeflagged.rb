# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A screening recorded a finding on an attendee. It says which attendee and how severe, not what they posted, who they are or why: GET the attendee report for the findings. Sent once per screening that flags the attendee, so a re-screen of someone on watch announces them again.
      class AttendeeFlagged
        extend T::Sig
        include Crystalline::MetadataFields

        # The attendee's event.
        field(
          :event_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_id"), required: true}}
        )
        # The flagged attendee.
        field(
          :attendee_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendee_id"), required: true}}
        )
        # The screening that flagged them.
        field(
          :screening_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("screening_id"), required: true}}
        )

        field(
          :highest_band,
          Models::Shared::HighestBand,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("highest_band"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::HighestBand, false)
            }
          }
        )
        # How sure the screening is that the accounts it read are the attendee's. A finding on a possible match is at most moderate, on a probable match at most high.
        field(
          :match_state,
          Models::Shared::AttendeeFlaggedMatchState,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("match_state"),
              required: true,
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::AttendeeFlaggedMatchState, false)
            }
          }
        )
        # When the screening recorded the finding; equal to the event's created_at.
        field(
          :flagged_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("flagged_at"), required: true}}
        )

        sig {
          params(
            event_id: ::String,
            attendee_id: ::String,
            screening_id: ::String,
            highest_band: Models::Shared::HighestBand,
            match_state: Models::Shared::AttendeeFlaggedMatchState,
            flagged_at: ::String
          )
            .void
        }
        def initialize(event_id:, attendee_id:, screening_id:, highest_band:, match_state:, flagged_at:)
          @event_id = event_id
          @attendee_id = attendee_id
          @screening_id = screening_id
          @highest_band = highest_band
          @match_state = match_state
          @flagged_at = flagged_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @event_id == other.event_id
          return false unless @attendee_id == other.attendee_id
          return false unless @screening_id == other.screening_id
          return false unless @highest_band == other.highest_band
          return false unless @match_state == other.match_state
          return false unless @flagged_at == other.flagged_at
          true
        end
      end
    end
  end
end
