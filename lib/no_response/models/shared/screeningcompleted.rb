# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A screening of an event finished. It counts only the attendees this screening set out to reach, not who they are: read the roster with GET /v1/workspaces/{workspace_id}/events/{environment}/{event_id}/attendees, filtered by band, to act on them. attendees_screened + partial_coverage = attendees_total, attendees_flagged is the sum of by_band, no_footprint counts screened attendees with no flag whose accounts were not found, and no_profile_to_check those the screening had nothing to look up for on any requested platform. A cancelled screening sends no event.
      class ScreeningCompleted
        extend T::Sig
        include Crystalline::MetadataFields

        # The screening that finished.
        field(
          :screening_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("screening_id"), required: true}}
        )
        # The event it screened.
        field(
          :event_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("event_id"), required: true}}
        )
        # completed reached every attendee; partial left some not fully covered (partial_coverage); failed covered nobody.
        field(
          :status,
          Models::Shared::ScreeningCompletedStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::ScreeningCompletedStatus, false)
            }
          }
        )
        # Every attendee the screening set out to reach: those no screening had reached and those on watch or escalated.
        field(
          :attendees_total,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendees_total"), required: true}}
        )
        # Attendees the screening covered, flagged or not.
        field(
          :attendees_screened,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendees_screened"), required: true}}
        )
        # Screened attendees with a finding: the sum of by_band.
        field(
          :attendees_flagged,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendees_flagged"), required: true}}
        )
        # Screened attendees by the band of their most severe finding.
        field(
          :by_band,
          Models::Shared::ScreeningCompletedByBand,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("by_band"), required: true}}
        )
        # Screened attendees with no finding whose accounts were not found (match_state none_found). A clean result for someone with no visible accounts is not the same as a clean result for someone whose accounts were read.
        field(
          :no_footprint,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("no_footprint"), required: true}}
        )
        # Attendees the screening did not fully cover. Read each one's coverage on its attendee.
        field(
          :partial_coverage,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("partial_coverage"), required: true}}
        )
        # When the screening finished; equal to the event's created_at.
        field(
          :finished_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("finished_at"), required: true}}
        )
        # Why a partial or failed screening stopped before reaching everyone, as the screening resource says: expired, worker_attempts_exhausted, attempts_exhausted or screening_unavailable.
        field(
          :error_code,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("error_code")}}
        )
        # Screened attendees with no profile to check: the list gave nothing to look up on any requested platform, such as no handle, so nobody looked for a profile (no_profile_to_check on the attendee). Not in no_footprint, and not partial: nothing failed. Their lookups are on their reports.
        field(
          :no_profile_to_check,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("no_profile_to_check")}}
        )

        sig {
          params(
            screening_id: ::String,
            event_id: ::String,
            status: Models::Shared::ScreeningCompletedStatus,
            attendees_total: ::Integer,
            attendees_screened: ::Integer,
            attendees_flagged: ::Integer,
            by_band: Models::Shared::ScreeningCompletedByBand,
            no_footprint: ::Integer,
            partial_coverage: ::Integer,
            finished_at: ::String,
            error_code: T.nilable(::String),
            no_profile_to_check: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          screening_id:,
          event_id:,
          status:,
          attendees_total:,
          attendees_screened:,
          attendees_flagged:,
          by_band:,
          no_footprint:,
          partial_coverage:,
          finished_at:,
          error_code: nil,
          no_profile_to_check: nil
        )
          @screening_id = screening_id
          @event_id = event_id
          @status = status
          @attendees_total = attendees_total
          @attendees_screened = attendees_screened
          @attendees_flagged = attendees_flagged
          @by_band = by_band
          @no_footprint = no_footprint
          @partial_coverage = partial_coverage
          @finished_at = finished_at
          @error_code = error_code
          @no_profile_to_check = no_profile_to_check
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @screening_id == other.screening_id
          return false unless @event_id == other.event_id
          return false unless @status == other.status
          return false unless @attendees_total == other.attendees_total
          return false unless @attendees_screened == other.attendees_screened
          return false unless @attendees_flagged == other.attendees_flagged
          return false unless @by_band == other.by_band
          return false unless @no_footprint == other.no_footprint
          return false unless @partial_coverage == other.partial_coverage
          return false unless @finished_at == other.finished_at
          return false unless @error_code == other.error_code
          return false unless @no_profile_to_check == other.no_profile_to_check
          true
        end
      end
    end
  end
end
