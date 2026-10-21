# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Normalized multi-factor evidence from a verified provider session.
      class AuthContextMfa
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :present,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("present")}}
        )

        field(
          :methods,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("methods")}}
        )

        field(
          :age_seconds,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("age_seconds")}}
        )

        sig {
          params(
            present: T.nilable(T::Boolean),
            methods: T.nilable(T::Array[::String]),
            age_seconds: T.nilable(::Integer)
          )
            .void
        }
        def initialize(present: nil, methods: nil, age_seconds: nil)
          @present = present
          @methods = methods
          @age_seconds = age_seconds
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @present == other.present
          return false unless @methods == other.methods
          return false unless @age_seconds == other.age_seconds
          true
        end
      end
    end
  end
end
