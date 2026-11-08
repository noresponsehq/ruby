# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Attendees in upload order.
      class AttendeeList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::Attendee),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )
        # Pass as after to read the next page.
        field(
          :next_after,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_after")}}
        )

        sig { params(items: T::Array[Models::Shared::Attendee], next_after: T.nilable(::String)).void }
        def initialize(items:, next_after: nil)
          @items = items
          @next_after = next_after
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @items == other.items
          return false unless @next_after == other.next_after
          true
        end
      end
    end
  end
end
