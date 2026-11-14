# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A screening recorded a finding on a person. It says which person and how severe, not what they posted, who they are or why: GET the person report for the findings. Sent once per screening that flags the person, so a re-screen of someone on watch announces them again.
      class PersonFlagged
        extend T::Sig
        include Crystalline::MetadataFields

        # The person's group.
        field(
          :group_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_id"), required: true}}
        )
        # The flagged person.
        field(
          :person_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person_id"), required: true}}
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
        # How sure the screening is that the accounts it read are the person's. A finding on a possible match is at most moderate, on a probable match at most high.
        field(
          :match_state,
          Models::Shared::PersonFlaggedMatchState,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("match_state"),
              required: true,
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::PersonFlaggedMatchState, false)
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
            group_id: ::String,
            person_id: ::String,
            screening_id: ::String,
            highest_band: Models::Shared::HighestBand,
            match_state: Models::Shared::PersonFlaggedMatchState,
            flagged_at: ::String
          )
            .void
        }
        def initialize(group_id:, person_id:, screening_id:, highest_band:, match_state:, flagged_at:)
          @group_id = group_id
          @person_id = person_id
          @screening_id = screening_id
          @highest_band = highest_band
          @match_state = match_state
          @flagged_at = flagged_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @group_id == other.group_id
          return false unless @person_id == other.person_id
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
