# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # How long and how widely the signup's email and username have existed, and how far independent sources agree on the person behind them, in years and counts only. families are the kinds of evidence that found either identifier. Omitted when nothing found them: a footprint lookup that failed makes no claim, and absence is no_digital_footprint's to state.
      class Footprint
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :families,
          Crystalline::Array.new(Models::Shared::FootprintFamily),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("families"), required: true}}
        )
        # One identifier's dated footprint across every source: the first and last year any event was seen, the years between them, the latest year a source dated activity (omitted when none did), how many distinct sites and which kinds of evidence saw it.
        field(
          :email,
          Crystalline::Nilable.new(Models::Shared::FootprintTimeline),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # One identifier's dated footprint across every source: the first and last year any event was seen, the years between them, the latest year a source dated activity (omitted when none did), how many distinct sites and which kinds of evidence saw it.
        field(
          :username,
          Crystalline::Nilable.new(Models::Shared::FootprintTimeline),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("username")}}
        )

        field(
          :coherence,
          Crystalline::Nilable.new(Models::Shared::FootprintCoherence),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("coherence")}}
        )

        sig {
          params(
            families: T::Array[Models::Shared::FootprintFamily],
            email: T.nilable(Models::Shared::FootprintTimeline),
            username: T.nilable(Models::Shared::FootprintTimeline),
            coherence: T.nilable(Models::Shared::FootprintCoherence)
          )
            .void
        }
        def initialize(families:, email: nil, username: nil, coherence: nil)
          @families = families
          @email = email
          @username = username
          @coherence = coherence
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @families == other.families
          return false unless @email == other.email
          return false unless @username == other.username
          return false unless @coherence == other.coherence
          true
        end
      end
    end
  end
end
