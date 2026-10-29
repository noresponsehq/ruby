# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Read immutable review resolution history.
      class ReviewResolutionList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::Resolution),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        field(
          :next_before_version,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_before_version")}}
        )

        sig { params(items: T::Array[Models::Shared::Resolution], next_before_version: T.nilable(::Integer)).void }
        def initialize(items:, next_before_version: nil)
          @items = items
          @next_before_version = next_before_version
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @items == other.items
          return false unless @next_before_version == other.next_before_version
          true
        end
      end
    end
  end
end
