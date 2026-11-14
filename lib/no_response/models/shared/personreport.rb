# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Everything known about one person, and where else in the environment they appear.
      class PersonReport
        extend T::Sig
        include Crystalline::MetadataFields

        # A person and where their screening and review stand.
        field(
          :person,
          Models::Shared::Person,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person"), required: true}}
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
          Crystalline::Array.new(Models::Shared::PersonReview),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reviews"), required: true}}
        )
        # Where else in the environment the person appears, read live from those groups: deleting one removes it here.
        field(
          :other_groups,
          Models::Shared::OtherGroups,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("other_groups"), required: true}}
        )
        # What the signup check's lookups found for a person: account presence for the email, phone and usernames (the person's handles), the phone lookup, the email domain's registration and the breach search. Context and coverage for the reviewer, not a finding: nothing here sets a band or a match state.
        field(
          :lookup,
          Crystalline::Nilable.new(Models::Shared::ScreeningLookup),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("lookup")}}
        )

        sig {
          params(
            person: Models::Shared::Person,
            profiles: T::Array[Models::Shared::ScreeningProfile],
            findings: T::Array[Models::Shared::ScreeningFinding],
            posts: T::Array[Models::Shared::ScreeningPost],
            media: T::Array[Models::Shared::ScreeningMedia],
            reviews: T::Array[Models::Shared::PersonReview],
            other_groups: Models::Shared::OtherGroups,
            lookup: T.nilable(Models::Shared::ScreeningLookup)
          )
            .void
        }
        def initialize(person:, profiles:, findings:, posts:, media:, reviews:, other_groups:, lookup: nil)
          @person = person
          @profiles = profiles
          @findings = findings
          @posts = posts
          @media = media
          @reviews = reviews
          @other_groups = other_groups
          @lookup = lookup
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @person == other.person
          return false unless @profiles == other.profiles
          return false unless @findings == other.findings
          return false unless @posts == other.posts
          return false unless @media == other.media
          return false unless @reviews == other.reviews
          return false unless @other_groups == other.other_groups
          return false unless @lookup == other.lookup
          true
        end
      end
    end
  end
end
