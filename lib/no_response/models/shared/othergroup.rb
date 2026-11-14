# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A person of another group in the same environment who shares an email or phone with this one, as that group recorded them.
      class OtherGroup
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :group_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_id"), required: true}}
        )

        field(
          :group_name,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_name"), required: true}}
        )

        field(
          :group_starts_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_starts_at"), required: true}}
        )
        # The person on that group's list.
        field(
          :person_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person_id"), required: true}}
        )
        # Which identifiers match, in this order. external_id appears only beside email or phone: the same external id alone is not a match, since ticket numbers may be reused across groups.
        field(
          :matched_on,
          Crystalline::Array.new(Models::Shared::MatchedOn),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("matched_on"), required: true}}
        )
        # How sure the latest screening is that it found the person's accounts. unscreened until a screening reaches the person, and after one that had no profile to check (no_profile_to_check).
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
        # true when that person's latest screening had no profile to check (see the person's no_profile_to_check). Left out otherwise.
        field(
          :no_profile_to_check,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("no_profile_to_check")}}
        )
        # That person's most severe band in that group, or null.
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
        # The latest reviewer decision in that group, or null before any.
        field(
          :decision,
          Crystalline::Nilable.new(Models::Shared::PersonDecision),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::PersonDecision, false)
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
            group_id: ::String,
            group_name: ::String,
            group_starts_at: ::String,
            person_id: ::String,
            matched_on: T::Array[Models::Shared::MatchedOn],
            match_state: Models::Shared::MatchState,
            no_profile_to_check: T.nilable(T::Boolean),
            highest_band: T.nilable(Models::Shared::HighestBand),
            decision: T.nilable(Models::Shared::PersonDecision),
            decided_by: T.nilable(::String),
            decided_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          group_id:,
          group_name:,
          group_starts_at:,
          person_id:,
          matched_on:,
          match_state:,
          no_profile_to_check: nil,
          highest_band: nil,
          decision: nil,
          decided_by: nil,
          decided_at: nil
        )
          @group_id = group_id
          @group_name = group_name
          @group_starts_at = group_starts_at
          @person_id = person_id
          @matched_on = matched_on
          @match_state = match_state
          @no_profile_to_check = no_profile_to_check
          @highest_band = highest_band
          @decision = decision
          @decided_by = decided_by
          @decided_at = decided_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @group_id == other.group_id
          return false unless @group_name == other.group_name
          return false unless @group_starts_at == other.group_starts_at
          return false unless @person_id == other.person_id
          return false unless @matched_on == other.matched_on
          return false unless @match_state == other.match_state
          return false unless @no_profile_to_check == other.no_profile_to_check
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
