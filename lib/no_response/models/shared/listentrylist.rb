# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Newest first. Without a query, returns every active entry for compatibility. With limit or cursor, returns up to 100 entries and an authenticated workspace/environment-bound cursor. Expired entries are omitted.
      class ListEntryList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::ListEntry),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        field(
          :next_cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_cursor")}}
        )

        sig { params(items: T::Array[Models::Shared::ListEntry], next_cursor: T.nilable(::String)).void }
        def initialize(items:, next_cursor: nil)
          @items = items
          @next_cursor = next_cursor
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @items == other.items
          return false unless @next_cursor == other.next_cursor
          true
        end
      end
    end
  end
end
