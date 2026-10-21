# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class RiskDetailsBreachName
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :value,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value"), required: true}}
        )

        field(
          :seen_in,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("seen_in"), required: true}}
        )

        sig { params(value: ::String, seen_in: ::Integer).void }
        def initialize(value:, seen_in:)
          @value = value
          @seen_in = seen_in
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @value == other.value
          return false unless @seen_in == other.seen_in
          true
        end
      end
    end
  end
end
