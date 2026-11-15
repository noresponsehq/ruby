# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # List investigation history.
      class InvestigationsList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::Investigation),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        field(
          :has_more,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("has_more"), required: true}}
        )

        field(
          :next_cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_cursor"), required: true}}
        )

        sig {
          params(items: T::Array[Models::Shared::Investigation], has_more: T::Boolean, next_cursor: T.nilable(::String))
            .void
        }
        def initialize(items:, has_more:, next_cursor: nil)
          @items = items
          @has_more = has_more
          @next_cursor = next_cursor
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @items == other.items
          return false unless @has_more == other.has_more
          return false unless @next_cursor == other.next_cursor
          true
        end
      end
    end
  end
end
