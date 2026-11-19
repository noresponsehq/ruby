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
        # The accounts this result matched, with how each was matched.
        field(
          :profiles,
          Crystalline::Array.new(Models::Shared::ScreeningProfile),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("profiles"), required: true}}
        )
        # All posts retained for this result.
        field(
          :posts,
          Crystalline::Array.new(Models::Shared::ScreeningPost),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("posts"), required: true}}
        )
        # All images and videos retained for this result.
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
        # The searches enrichment would start on this person in this group, likeliest record first. Group screening follows the environment's enrichment setting, with suggest as its mode while the workspace has not set one. In off mode the list is empty. In suggest mode enrichment starts none of them by itself; in automatic mode it starts them as its limits allow. Empty when evidence.read is denied.
        field(
          :suggested_searches,
          Crystalline::Array.new(Models::Shared::SuggestedSearch),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("suggested_searches"), required: true}}
        )
        # Where else in the environment the person appears, read live from those groups: deleting one removes it here.
        field(
          :other_groups,
          Models::Shared::OtherGroups,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("other_groups"), required: true}}
        )
        # What the signup check's lookups found for a person: account presence for the email, phone and usernames (the person's handles), the phone lookup, the email domain's registration and the breach search. Nothing here sets a match state.
        field(
          :lookup,
          Crystalline::Nilable.new(Models::Shared::ScreeningLookup),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("lookup")}}
        )
        # The searches on this person's values in this group, newest first: each names the value, the record and field it came from, and the search that found that record. Absent when nothing was searched.
        field(
          :searches,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Search)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("searches")}}
        )
        # True when evidence.read is explicitly denied. Submitted details, coverage, job status and decisions remain available. Collected records, profiles, posts, media, discovered values and free-text decision notes are withheld.
        field(
          :evidence_restricted,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evidence_restricted")}}
        )

        sig {
          params(
            person: Models::Shared::Person,
            profiles: T::Array[Models::Shared::ScreeningProfile],
            posts: T::Array[Models::Shared::ScreeningPost],
            media: T::Array[Models::Shared::ScreeningMedia],
            reviews: T::Array[Models::Shared::PersonReview],
            suggested_searches: T::Array[Models::Shared::SuggestedSearch],
            other_groups: Models::Shared::OtherGroups,
            lookup: T.nilable(Models::Shared::ScreeningLookup),
            searches: T.nilable(T::Array[Models::Shared::Search]),
            evidence_restricted: T.nilable(T::Boolean)
          )
            .void
        }
        def initialize(
          person:,
          profiles:,
          posts:,
          media:,
          reviews:,
          suggested_searches:,
          other_groups:,
          lookup: nil,
          searches: nil,
          evidence_restricted: nil
        )
          @person = person
          @profiles = profiles
          @posts = posts
          @media = media
          @reviews = reviews
          @suggested_searches = suggested_searches
          @other_groups = other_groups
          @lookup = lookup
          @searches = searches
          @evidence_restricted = evidence_restricted
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @person == other.person
          return false unless @profiles == other.profiles
          return false unless @posts == other.posts
          return false unless @media == other.media
          return false unless @reviews == other.reviews
          return false unless @suggested_searches == other.suggested_searches
          return false unless @other_groups == other.other_groups
          return false unless @lookup == other.lookup
          return false unless @searches == other.searches
          return false unless @evidence_restricted == other.evidence_restricted
          true
        end
      end
    end
  end
end
