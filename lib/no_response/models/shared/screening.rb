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
          :event_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_id"), required: true}}
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
        # partial finished with some attendees not covered; attendees_failed counts them.
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
          Crystalline::Array.new(Models::Shared::ScreeningPlatform),
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
        # Attendees selected when the screening started.
        field(
          :attendees_total,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendees_total"), required: true}}
        )
        # Attendees screened so far, failed ones included.
        field(
          :attendees_done,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendees_done"), required: true}}
        )

        field(
          :attendees_flagged,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendees_flagged"), required: true}}
        )

        field(
          :attendees_failed,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendees_failed"), required: true}}
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
            event_id: ::String,
            environment: Models::Shared::AuditSettingsEnvironment,
            status: Models::Shared::ScreeningStatus,
            depth: Models::Shared::ScreeningDepth,
            platforms: T::Array[Models::Shared::ScreeningPlatform],
            requested_by: ::String,
            created_at: ::String,
            expires_at: ::String,
            attendees_total: ::Integer,
            attendees_done: ::Integer,
            attendees_flagged: ::Integer,
            attendees_failed: ::Integer,
            started_at: T.nilable(::String),
            finished_at: T.nilable(::String),
            error_code: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          event_id:,
          environment:,
          status:,
          depth:,
          platforms:,
          requested_by:,
          created_at:,
          expires_at:,
          attendees_total:,
          attendees_done:,
          attendees_flagged:,
          attendees_failed:,
          started_at: nil,
          finished_at: nil,
          error_code: nil
        )
          @id = id
          @event_id = event_id
          @environment = environment
          @status = status
          @depth = depth
          @platforms = platforms
          @requested_by = requested_by
          @created_at = created_at
          @expires_at = expires_at
          @attendees_total = attendees_total
          @attendees_done = attendees_done
          @attendees_flagged = attendees_flagged
          @attendees_failed = attendees_failed
          @started_at = started_at
          @finished_at = finished_at
          @error_code = error_code
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @event_id == other.event_id
          return false unless @environment == other.environment
          return false unless @status == other.status
          return false unless @depth == other.depth
          return false unless @platforms == other.platforms
          return false unless @requested_by == other.requested_by
          return false unless @created_at == other.created_at
          return false unless @expires_at == other.expires_at
          return false unless @attendees_total == other.attendees_total
          return false unless @attendees_done == other.attendees_done
          return false unless @attendees_flagged == other.attendees_flagged
          return false unless @attendees_failed == other.attendees_failed
          return false unless @started_at == other.started_at
          return false unless @finished_at == other.finished_at
          return false unless @error_code == other.error_code
          true
        end
      end
    end
  end
end
