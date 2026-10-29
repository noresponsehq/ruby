# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Current resolution of each resolved retained review; prior resolutions and reopened reviews do not count. Missing keys mean zero. These investigation conclusions are independent of account feedback.
      class ReviewsConclusions
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :benign,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("benign")}}
        )

        field(
          :abuse,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("abuse")}}
        )

        field(
          :inconclusive,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("inconclusive")}}
        )

        sig {
          params(benign: T.nilable(::Integer), abuse: T.nilable(::Integer), inconclusive: T.nilable(::Integer)).void
        }
        def initialize(benign: nil, abuse: nil, inconclusive: nil)
          @benign = benign
          @abuse = abuse
          @inconclusive = inconclusive
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @benign == other.benign
          return false unless @abuse == other.abuse
          return false unless @inconclusive == other.inconclusive
          true
        end
      end
    end
  end
end
