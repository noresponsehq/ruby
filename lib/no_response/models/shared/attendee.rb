# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # An attendee and where their screening and review stand.
      class Attendee
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :event_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_id"), required: true}}
        )
        # The attendee's full name.
        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}
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
        # The denominator of a screening: accounts found, how many could be read, items read and the period they span, so a clean result is distinct from a person nobody could see.
        field(
          :coverage,
          Models::Shared::ScreeningCoverage,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("coverage"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :updated_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_at"), required: true}}
        )
        # What screening cost, in US cents, in total and per implementation.
        field(
          :spend,
          Models::Shared::ScreeningSpend,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("spend"), required: true}}
        )
        # Your own id for the attendee, unique within the event. A later row with the same external id updates this attendee.
        field(
          :external_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_id")}}
        )
        # The attendee's email.
        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # The attendee's phone in E.164 form.
        field(
          :phone,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone")}}
        )
        # Where the attendee works.
        field(
          :company,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("company")}}
        )
        # Where the attendee lives.
        field(
          :city,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("city")}}
        )
        # Accounts the attendee is known to hold, at most 20.
        field(
          :handles,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Handle)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("handles")}}
        )
        # The most severe finding's band, or null when nothing was flagged.
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
        # The latest reviewer decision, or null before any.
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

        field(
          :decision_note,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decision_note")}}
        )

        field(
          :decided_by,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decided_by")}}
        )

        field(
          :decided_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decided_at")}}
        )

        field(
          :last_screening_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("last_screening_id")}}
        )

        field(
          :screened_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("screened_at")}}
        )

        sig {
          params(
            id: ::String,
            event_id: ::String,
            name: ::String,
            match_state: Models::Shared::MatchState,
            coverage: Models::Shared::ScreeningCoverage,
            created_at: ::String,
            updated_at: ::String,
            spend: Models::Shared::ScreeningSpend,
            external_id: T.nilable(::String),
            email: T.nilable(::String),
            phone: T.nilable(::String),
            company: T.nilable(::String),
            city: T.nilable(::String),
            handles: T.nilable(T::Array[Models::Shared::Handle]),
            highest_band: T.nilable(Models::Shared::HighestBand),
            decision: T.nilable(Models::Shared::AttendeeDecision),
            decision_note: T.nilable(::String),
            decided_by: T.nilable(::String),
            decided_at: T.nilable(::String),
            last_screening_id: T.nilable(::String),
            screened_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          event_id:,
          name:,
          match_state:,
          coverage:,
          created_at:,
          updated_at:,
          spend:,
          external_id: nil,
          email: nil,
          phone: nil,
          company: nil,
          city: nil,
          handles: nil,
          highest_band: nil,
          decision: nil,
          decision_note: nil,
          decided_by: nil,
          decided_at: nil,
          last_screening_id: nil,
          screened_at: nil
        )
          @id = id
          @event_id = event_id
          @name = name
          @match_state = match_state
          @coverage = coverage
          @created_at = created_at
          @updated_at = updated_at
          @spend = spend
          @external_id = external_id
          @email = email
          @phone = phone
          @company = company
          @city = city
          @handles = handles
          @highest_band = highest_band
          @decision = decision
          @decision_note = decision_note
          @decided_by = decided_by
          @decided_at = decided_at
          @last_screening_id = last_screening_id
          @screened_at = screened_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @event_id == other.event_id
          return false unless @name == other.name
          return false unless @match_state == other.match_state
          return false unless @coverage == other.coverage
          return false unless @created_at == other.created_at
          return false unless @updated_at == other.updated_at
          return false unless @spend == other.spend
          return false unless @external_id == other.external_id
          return false unless @email == other.email
          return false unless @phone == other.phone
          return false unless @company == other.company
          return false unless @city == other.city
          return false unless @handles == other.handles
          return false unless @highest_band == other.highest_band
          return false unless @decision == other.decision
          return false unless @decision_note == other.decision_note
          return false unless @decided_by == other.decided_by
          return false unless @decided_at == other.decided_at
          return false unless @last_screening_id == other.last_screening_id
          return false unless @screened_at == other.screened_at
          true
        end
      end
    end
  end
end
