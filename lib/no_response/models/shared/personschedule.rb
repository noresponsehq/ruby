# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The person's rerun schedule. Each due run starts a full investigation of the person, as POST /v1/investigations with no platforms does, and its changes are stored as changes. The schedule lives in the database and the worker runs it, so it survives restarts and releases; each due run starts exactly one investigation.
      class PersonSchedule
        extend T::Sig
        include Crystalline::MetadataFields

        # How often the person is investigated again: daily, weekly or monthly, counted from when the schedule was set; off runs no scheduled investigation.
        field(
          :period,
          Models::Shared::SchedulePeriod,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("period"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::SchedulePeriod, false)
            }
          }
        )
        # When the next scheduled investigation starts, within a minute. null when the schedule is off.
        field(
          :next_run_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_run_at"), required: true}}
        )
        # The investigation the schedule last started. null before its first run.
        field(
          :last_investigation_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("last_investigation_id"), required: true}}
        )
        # Why the last due run started no investigation, as the problem code its start would have answered. null when the last due run started one, or none has come due. A run that started none is not retried: the schedule moves to its next period.
        field(
          :last_error,
          Crystalline::Nilable.new(Models::Shared::LastError),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("last_error"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::LastError, false)
            }
          }
        )

        field(
          :updated_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_at"), required: true}}
        )
        # Who last set the schedule.
        field(
          :updated_by,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_by"), required: true}}
        )

        sig {
          params(
            period: Models::Shared::SchedulePeriod,
            next_run_at: T.nilable(::String),
            last_investigation_id: T.nilable(::String),
            last_error: T.nilable(Models::Shared::LastError),
            updated_at: T.nilable(::String),
            updated_by: T.nilable(::String)
          )
            .void
        }
        def initialize(
          period:,
          next_run_at: nil,
          last_investigation_id: nil,
          last_error: nil,
          updated_at: nil,
          updated_by: nil
        )
          @period = period
          @next_run_at = next_run_at
          @last_investigation_id = last_investigation_id
          @last_error = last_error
          @updated_at = updated_at
          @updated_by = updated_by
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @period == other.period
          return false unless @next_run_at == other.next_run_at
          return false unless @last_investigation_id == other.last_investigation_id
          return false unless @last_error == other.last_error
          return false unless @updated_at == other.updated_at
          return false unless @updated_by == other.updated_by
          true
        end
      end
    end
  end
end
