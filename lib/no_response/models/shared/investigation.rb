# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Investigation
        extend T::Sig
        include Crystalline::MetadataFields

        # The denominator of a screening: accounts found, how many could be read, items read and the period they span, so a clean result is distinct from a person nobody could see.
        field(
          :coverage,
          Models::Shared::ScreeningCoverage,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("coverage"), required: true}}
        )
        # What screening cost, in US cents, in total and per implementation.
        field(
          :spend,
          Models::Shared::ScreeningSpend,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("spend"), required: true}}
        )

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :person_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person_id"), required: true}}
        )

        field(
          :status,
          Models::Shared::InvestigationStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::InvestigationStatus, false)
            }
          }
        )

        field(
          :depth,
          Models::Shared::ScreeningDepth,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("depth"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ScreeningDepth, false)
            }
          }
        )

        field(
          :platforms,
          Crystalline::Array.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("platforms"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )

        field(
          :deadline_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("deadline_at"), required: true}}
        )

        field(
          :group_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_id"), required: true}}
        )

        field(
          :match_state,
          Crystalline::Nilable.new(Models::Shared::MatchState),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("match_state"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::MatchState, false)
            }
          }
        )

        field(
          :error_code,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("error_code")}}
        )

        field(
          :started_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("started_at")}}
        )

        field(
          :finished_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("finished_at")}}
        )

        sig {
          params(
            coverage: Models::Shared::ScreeningCoverage,
            spend: Models::Shared::ScreeningSpend,
            id: ::String,
            person_id: ::String,
            status: Models::Shared::InvestigationStatus,
            depth: Models::Shared::ScreeningDepth,
            platforms: T::Array[::String],
            created_at: ::String,
            expires_at: ::String,
            deadline_at: ::String,
            group_id: T.nilable(::String),
            match_state: T.nilable(Models::Shared::MatchState),
            error_code: T.nilable(::String),
            started_at: T.nilable(::String),
            finished_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          coverage:,
          spend:,
          id:,
          person_id:,
          status:,
          depth:,
          platforms:,
          created_at:,
          expires_at:,
          deadline_at:,
          group_id: nil,
          match_state: nil,
          error_code: nil,
          started_at: nil,
          finished_at: nil
        )
          @coverage = coverage
          @spend = spend
          @id = id
          @person_id = person_id
          @status = status
          @depth = depth
          @platforms = platforms
          @created_at = created_at
          @expires_at = expires_at
          @deadline_at = deadline_at
          @group_id = group_id
          @match_state = match_state
          @error_code = error_code
          @started_at = started_at
          @finished_at = finished_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @coverage == other.coverage
          return false unless @spend == other.spend
          return false unless @id == other.id
          return false unless @person_id == other.person_id
          return false unless @status == other.status
          return false unless @depth == other.depth
          return false unless @platforms == other.platforms
          return false unless @created_at == other.created_at
          return false unless @expires_at == other.expires_at
          return false unless @deadline_at == other.deadline_at
          return false unless @group_id == other.group_id
          return false unless @match_state == other.match_state
          return false unless @error_code == other.error_code
          return false unless @started_at == other.started_at
          return false unless @finished_at == other.finished_at
          true
        end
      end
    end
  end
end
