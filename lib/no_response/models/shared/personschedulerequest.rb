# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The schedule to set.
      class PersonScheduleRequest
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

        sig { params(period: Models::Shared::SchedulePeriod).void }
        def initialize(period:)
          @period = period
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @period == other.period
          true
        end
      end
    end
  end
end
