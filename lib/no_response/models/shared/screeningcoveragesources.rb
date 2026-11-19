# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # How many sources this search asked and how many answered, across the lookup stage (sources asked whether an account exists for an identifier) and the platform stage (profiles read on each platform). A source that answered may have found nothing; one that did not answer failed or ran out of time.
      class ScreeningCoverageSources
        extend T::Sig
        include Crystalline::MetadataFields

        # Lookup sources plus platforms asked.
        field(
          :asked,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("asked"), required: true}}
        )
        # Lookup sources plus platforms that answered.
        field(
          :answered,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("answered"), required: true}}
        )

        field(
          :lookups,
          Models::Shared::SourceCount,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("lookups"), required: true}}
        )

        field(
          :platforms,
          Models::Shared::SourceCount,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("platforms"), required: true}}
        )

        sig {
          params(
            asked: ::Integer,
            answered: ::Integer,
            lookups: Models::Shared::SourceCount,
            platforms: Models::Shared::SourceCount
          )
            .void
        }
        def initialize(asked:, answered:, lookups:, platforms:)
          @asked = asked
          @answered = answered
          @lookups = lookups
          @platforms = platforms
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @asked == other.asked
          return false unless @answered == other.answered
          return false unless @lookups == other.lookups
          return false unless @platforms == other.platforms
          true
        end
      end
    end
  end
end
