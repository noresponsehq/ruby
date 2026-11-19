# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Read an investigation and its evidence.
      class InvestigationReport
        extend T::Sig
        include Crystalline::MetadataFields

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

        field(
          :person,
          Models::Shared::WorkspacePerson,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person"), required: true}}
        )

        field(
          :investigation,
          Models::Shared::Investigation,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("investigation"), required: true}}
        )
        # What the signup check's lookups found for a person: account presence for the email, phone and usernames (the person's handles), the phone lookup, the email domain's registration and the breach search. Nothing here sets a match state.
        field(
          :lookup,
          Crystalline::Nilable.new(Models::Shared::ScreeningLookup),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("lookup")}}
        )
        # True when evidence.read is explicitly denied. Submitted details, coverage, job status and decisions remain available. Collected records, profiles, posts, media, discovered values and free-text decision notes are withheld.
        field(
          :evidence_restricted,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evidence_restricted")}}
        )

        sig {
          params(
            profiles: T::Array[Models::Shared::ScreeningProfile],
            posts: T::Array[Models::Shared::ScreeningPost],
            media: T::Array[Models::Shared::ScreeningMedia],
            reviews: T::Array[Models::Shared::PersonReview],
            person: Models::Shared::WorkspacePerson,
            investigation: Models::Shared::Investigation,
            lookup: T.nilable(Models::Shared::ScreeningLookup),
            evidence_restricted: T.nilable(T::Boolean)
          )
            .void
        }
        def initialize(
          profiles:,
          posts:,
          media:,
          reviews:,
          person:,
          investigation:,
          lookup: nil,
          evidence_restricted: nil
        )
          @profiles = profiles
          @posts = posts
          @media = media
          @reviews = reviews
          @person = person
          @investigation = investigation
          @lookup = lookup
          @evidence_restricted = evidence_restricted
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @profiles == other.profiles
          return false unless @posts == other.posts
          return false unless @media == other.media
          return false unless @reviews == other.reviews
          return false unless @person == other.person
          return false unless @investigation == other.investigation
          return false unless @lookup == other.lookup
          return false unless @evidence_restricted == other.evidence_restricted
          true
        end
      end
    end
  end
end
