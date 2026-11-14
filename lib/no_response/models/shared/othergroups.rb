# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Where else in the environment the person appears, read live from those groups: deleting one removes it here.
      class OtherGroups
        extend T::Sig
        include Crystalline::MetadataFields

        # How many people of other groups match, of which items lists the 20 most recent.
        field(
          :total,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("total"), required: true}}
        )
        # The 20 people of the most recent other groups, newest group first.
        field(
          :items,
          Crystalline::Array.new(Models::Shared::OtherGroup),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig { params(total: ::Integer, items: T::Array[Models::Shared::OtherGroup]).void }
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
