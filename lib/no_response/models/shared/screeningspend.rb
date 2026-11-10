# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # What screening cost, in US cents, in total and per implementation.
      class ScreeningSpend
        extend T::Sig
        include Crystalline::MetadataFields

        # The total, in US cents.
        field(
          :total_minor,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("total_minor"), required: true}}
        )

        field(
          :by_implementation,
          Crystalline::Array.new(Models::Shared::ScreeningSpendLine),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("by_implementation"), required: true}}
        )

        sig { params(total_minor: ::Integer, by_implementation: T::Array[Models::Shared::ScreeningSpendLine]).void }
        def initialize(total_minor:, by_implementation:)
          @total_minor = total_minor
          @by_implementation = by_implementation
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @total_minor == other.total_minor
          return false unless @by_implementation == other.by_implementation
          true
        end
      end
    end
  end
end
