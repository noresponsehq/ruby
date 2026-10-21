# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class RiskDetailsPhoneName
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :value,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value"), required: true}}
        )

        field(
          :seen_by,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("seen_by"), required: true}}
        )

        sig { params(value: ::String, seen_by: ::Integer).void }
        def initialize(value:, seen_by:)
          @value = value
          @seen_by = seen_by
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @value == other.value
          return false unless @seen_by == other.seen_by
          true
        end
      end
    end
  end
end
