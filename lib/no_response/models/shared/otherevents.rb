# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Where else in the environment the attendee appears, read live from those events: deleting one removes it here.
      class OtherEvents
        extend T::Sig
        include Crystalline::MetadataFields

        # How many attendees of other events match, of which items lists the 20 most recent.
        field(
          :total,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("total"), required: true}}
        )
        # The 20 attendees of the most recent other events, newest event first.
        field(
          :items,
          Crystalline::Array.new(Models::Shared::OtherEvent),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig { params(total: ::Integer, items: T::Array[Models::Shared::OtherEvent]).void }
        def initialize(total:, items:)
          @total = total
          @items = items
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @total == other.total
          return false unless @items == other.items
          true
        end
      end
    end
  end
end
