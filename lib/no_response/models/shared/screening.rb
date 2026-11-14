# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A screening and its progress.
      class Screening
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :group_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_id"), required: true}}
        )

        field(
          :environment,
          Models::Shared::AuditSettingsEnvironment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AuditSettingsEnvironment, false)
            }
          }
        )
        # partial finished with some people or platforms not covered; people_failed and people_partial count them.
        field(
          :status,
          Models::Shared::ScreeningStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ScreeningStatus, false)
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
          Crystalline::Array.new(Models::Shared::HandlePlatform),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("platforms"), required: true}}
        )

        field(
          :requested_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("requested_by"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # A screening still running then fails with error_code expired.
        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )
        # People selected when the screening started.
        field(
          :people_total,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("people_total"), required: true}}
        )
        # People screened so far, failed ones included.
        field(
          :people_done,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("people_done"), required: true}}
        )

        field(
          :people_flagged,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("people_flagged"), required: true}}
        )

        field(
          :people_failed,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("people_failed"), required: true}}
        )
        # People screened with some requested platform not covered; their coverage names which.
        field(
          :people_partial,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("people_partial"), required: true}}
        )
        # What the screening was estimated to cost when it started, in minor units of USD (cents): its people at its depth and platforms. Until the screening finishes, what it has not yet spent counts against the environment's screening_daily_cap.
        field(
          :estimated_spend,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("estimated_spend"), required: true}}
        )
        # What the people it has screened recorded, in minor units of USD. Each counts toward the UTC day it was recorded on; a failed person records nothing.
        field(
          :spent,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("spent"), required: true}}
        )
        # What screening cost, in US cents, in total and per implementation.
        field(
          :spend,
          Models::Shared::ScreeningSpend,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("spend"), required: true}}
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
        # Why a failed or cancelled screening stopped.
        field(
          :error_code,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("error_code")}}
        )

        sig {
          params(
            id: ::String,
            group_id: ::String,
            environment: Models::Shared::AuditSettingsEnvironment,
            status: Models::Shared::ScreeningStatus,
            depth: Models::Shared::ScreeningDepth,
            platforms: T::Array[Models::Shared::HandlePlatform],
            requested_by: ::String,
            created_at: ::String,
            expires_at: ::String,
            people_total: ::Integer,
            people_done: ::Integer,
            people_flagged: ::Integer,
            people_failed: ::Integer,
            people_partial: ::Integer,
            estimated_spend: ::Integer,
            spent: ::Integer,
            spend: Models::Shared::ScreeningSpend,
            started_at: T.nilable(::String),
            finished_at: T.nilable(::String),
            error_code: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          group_id:,
          environment:,
          status:,
          depth:,
          platforms:,
          requested_by:,
          created_at:,
          expires_at:,
          people_total:,
          people_done:,
          people_flagged:,
          people_failed:,
          people_partial:,
          estimated_spend:,
          spent:,
          spend:,
          started_at: nil,
          finished_at: nil,
          error_code: nil
        )
          @id = id
          @group_id = group_id
          @environment = environment
          @status = status
          @depth = depth
          @platforms = platforms
          @requested_by = requested_by
          @created_at = created_at
          @expires_at = expires_at
          @people_total = people_total
          @people_done = people_done
          @people_flagged = people_flagged
          @people_failed = people_failed
          @people_partial = people_partial
          @estimated_spend = estimated_spend
          @spent = spent
          @spend = spend
          @started_at = started_at
          @finished_at = finished_at
          @error_code = error_code
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @group_id == other.group_id
          return false unless @environment == other.environment
          return false unless @status == other.status
          return false unless @depth == other.depth
          return false unless @platforms == other.platforms
          return false unless @requested_by == other.requested_by
          return false unless @created_at == other.created_at
          return false unless @expires_at == other.expires_at
          return false unless @people_total == other.people_total
          return false unless @people_done == other.people_done
          return false unless @people_flagged == other.people_flagged
          return false unless @people_failed == other.people_failed
          return false unless @people_partial == other.people_partial
          return false unless @estimated_spend == other.estimated_spend
          return false unless @spent == other.spent
          return false unless @spend == other.spend
          return false unless @started_at == other.started_at
          return false unless @finished_at == other.finished_at
          return false unless @error_code == other.error_code
          true
        end
      end
    end
  end
end
