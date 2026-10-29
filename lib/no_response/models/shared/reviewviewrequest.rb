# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ReviewViewRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}

        field(
          :shared,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("shared"), required: true}}
        )

        field(
          :filter,
          Models::Shared::Filter,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("filter"), required: true}}
        )

        field(
          :expected_version,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_version")}}
        )

        sig {
          params(
            name: ::String,
            shared: T::Boolean,
            filter: Models::Shared::Filter,
            expected_version: T.nilable(::Integer)
          )
            .void
        }
        def initialize(name:, shared:, filter:, expected_version: nil)
          @name = name
          @shared = shared
          @filter = filter
          @expected_version = expected_version
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @shared == other.shared
          return false unless @filter == other.filter
          return false unless @expected_version == other.expected_version
          true
        end
      end
    end
  end
end
