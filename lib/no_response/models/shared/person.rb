# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A person and where their screening and review stand.
      class Person
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :group_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_id"), required: true}}
        )
        # The person's full name.
        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}
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
        # Your own id for the person, unique within the group. A later row with the same external id updates this person.
        field(
          :external_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_id")}}
        )
        # The person's email.
        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # The person's phone in E.164 form.
        field(
          :phone,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone")}}
        )
        # Where the person works.
        field(
          :company,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("company")}}
        )
        # Where the person lives.
        field(
          :city,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("city")}}
        )
        # Accounts the person is known to hold, at most 20.
        field(
          :handles,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Handle)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("handles")}}
        )
        # The person's role in the group: guest (a ticket holder), crew, vendor or press. Leave it out when you do not know it: a person without one has no role, not guest. A later row naming the same person replaces it, and a change of role alone keeps the person's screening results.
        field(
          :role,
          Crystalline::Nilable.new(Models::Shared::PersonRole),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("role"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::PersonRole, true)
            }
          }
        )
        # true when the latest screening reached the person but the list gave nothing to look up on any requested platform, such as no handle for a platform that reads supplied handles only: nobody looked for a profile. match_state stays unscreened, every platform is in coverage.not_searched, and the person is neither none_found nor failed and does not make the screening partial. Its lookups are on its report. Left out otherwise.
        field(
          :no_profile_to_check,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("no_profile_to_check")}}
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
          Crystalline::Nilable.new(Models::Shared::PersonDecision),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::PersonDecision, false)
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
            group_id: ::String,
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
            role: T.nilable(Models::Shared::PersonRole),
            no_profile_to_check: T.nilable(T::Boolean),
            highest_band: T.nilable(Models::Shared::HighestBand),
            decision: T.nilable(Models::Shared::PersonDecision),
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
          group_id:,
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
          role: nil,
          no_profile_to_check: nil,
          highest_band: nil,
          decision: nil,
          decision_note: nil,
          decided_by: nil,
          decided_at: nil,
          last_screening_id: nil,
          screened_at: nil
        )
          @id = id
          @group_id = group_id
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
          @role = role
          @no_profile_to_check = no_profile_to_check
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
          return false unless @group_id == other.group_id
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
          return false unless @role == other.role
          return false unless @no_profile_to_check == other.no_profile_to_check
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
