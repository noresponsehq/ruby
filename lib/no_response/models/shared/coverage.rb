# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Counts only; a zero denominator means no eligible retained records and does not imply a zero rate.
      class Coverage
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :numerator,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("numerator"), required: true}}
        )

        field(
          :denominator,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("denominator"), required: true}}
        )

        sig { params(numerator: ::Integer, denominator: ::Integer).void }
        def initialize(numerator:, denominator:)
          @numerator = numerator
          @denominator = denominator
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @numerator == other.numerator
          return false unless @denominator == other.denominator
          true
        end
      end
    end
  end
end
