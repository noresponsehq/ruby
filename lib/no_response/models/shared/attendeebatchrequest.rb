# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Adds or updates 1 to 500 attendees. A row naming an existing attendee of the event (the same external_id, else the same email, else the same phone) updates it.
      class AttendeeBatchRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :attendees,
          Crystalline::Array.new(Models::Shared::AttendeeIdentity),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendees"), required: true}}
        )

        sig { params(attendees: T::Array[Models::Shared::AttendeeIdentity]).void }
        def initialize(attendees:)
          @attendees = attendees
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @attendees == other.attendees
          true
        end
      end
    end
  end
end
