# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Everything known about one attendee.
      class AttendeeReport
        extend T::Sig
        include Crystalline::MetadataFields

        # An attendee and where their screening and review stand.
        field(
          :attendee,
          Models::Shared::Attendee,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attendee"), required: true}}
        )
        # The accounts the screening matched, with how each was matched.
        field(
          :profiles,
          Crystalline::Array.new(Models::Shared::Profile),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("profiles"), required: true}}
        )
        # What the screening flagged, with its evidence.
        field(
          :findings,
          Crystalline::Array.new(Models::Shared::Finding),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("findings"), required: true}}
        )
        # Every recorded decision, oldest first.
        field(
          :reviews,
          Crystalline::Array.new(Models::Shared::AttendeeReview),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reviews"), required: true}}
        )

        sig {
          params(
            attendee: Models::Shared::Attendee,
            profiles: T::Array[Models::Shared::Profile],
            findings: T::Array[Models::Shared::Finding],
            reviews: T::Array[Models::Shared::AttendeeReview]
          )
            .void
        }
        def initialize(attendee:, profiles:, findings:, reviews:)
          @attendee = attendee
          @profiles = profiles
          @findings = findings
          @reviews = reviews
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @attendee == other.attendee
          return false unless @profiles == other.profiles
          return false unless @findings == other.findings
          return false unless @reviews == other.reviews
          true
        end
      end
    end
  end
end
