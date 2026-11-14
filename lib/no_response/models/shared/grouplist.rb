# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Groups, newest first.
      class GroupList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::Group),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )
        # Pass as before to read the next, older page.
        field(
          :next_before,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_before")}}
        )

        sig { params(items: T::Array[Models::Shared::Group], next_before: T.nilable(::String)).void }
        def initialize(items:, next_before: nil)
          @items = items
          @next_before = next_before
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @items == other.items
          return false unless @next_before == other.next_before
          true
        end
      end
    end
  end
end
