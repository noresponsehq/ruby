# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ProblemInvalidParam
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :field,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("field"), required: true}}
        )

        field(
          :reason,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reason"), required: true}}
        )

        field(
          :example,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("example")}}
        )

        sig { params(field: ::String, reason: ::String, example: T.nilable(::String)).void }
        def initialize(field:, reason:, example: nil)
          @field = field
          @reason = reason
          @example = example
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @field == other.field
          return false unless @reason == other.reason
          return false unless @example == other.example
          true
        end
      end
    end
  end
end
