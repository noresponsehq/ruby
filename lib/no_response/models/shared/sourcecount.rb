# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class SourceCount
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :asked,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("asked"), required: true}}
        )

        field(
          :answered,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("answered"), required: true}}
        )

        sig { params(asked: ::Integer, answered: ::Integer).void }
        def initialize(asked:, answered:)
          @asked = asked
          @answered = answered
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @asked == other.asked
          return false unless @answered == other.answered
          true
        end
      end
    end
  end
end
