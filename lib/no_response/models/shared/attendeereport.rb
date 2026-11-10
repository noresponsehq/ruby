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
        # The accounts the latest screening matched, with how each was matched.
        field(
          :profiles,
          Crystalline::Array.new(Models::Shared::ScreeningProfile),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("profiles"), required: true}}
        )
        # What the latest screening flagged, most severe first, each citing its evidence.
        field(
          :findings,
          Crystalline::Array.new(Models::Shared::ScreeningFinding),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("findings"), required: true}}
        )
        # The posts the findings cite.
        field(
          :posts,
          Crystalline::Array.new(Models::Shared::ScreeningPost),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("posts"), required: true}}
        )
        # The images and videos the findings cite.
        field(
          :media,
          Crystalline::Array.new(Models::Shared::ScreeningMedia),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("media"), required: true}}
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
            profiles: T::Array[Models::Shared::ScreeningProfile],
            findings: T::Array[Models::Shared::ScreeningFinding],
            posts: T::Array[Models::Shared::ScreeningPost],
            media: T::Array[Models::Shared::ScreeningMedia],
            reviews: T::Array[Models::Shared::AttendeeReview]
          )
            .void
        }
        def initialize(attendee:, profiles:, findings:, posts:, media:, reviews:)
          @attendee = attendee
          @profiles = profiles
          @findings = findings
          @posts = posts
          @media = media
          @reviews = reviews
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @attendee == other.attendee
          return false unless @profiles == other.profiles
          return false unless @findings == other.findings
          return false unless @posts == other.posts
          return false unless @media == other.media
          return false unless @reviews == other.reviews
          true
        end
      end
    end
  end
end
