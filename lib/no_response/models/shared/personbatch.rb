# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # What the batch did, row by row.
      class PersonBatch
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :created,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created"), required: true}}
        )

        field(
          :updated,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated"), required: true}}
        )

        field(
          :items,
          Crystalline::Array.new(Models::Shared::PersonBatchItem),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig { params(created: ::Integer, updated: ::Integer, items: T::Array[Models::Shared::PersonBatchItem]).void }
        def initialize(created:, updated:, items:)
          @created = created
          @updated = updated
          @items = items
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @created == other.created
          return false unless @updated == other.updated
          return false unless @items == other.items
          true
        end
      end
    end
  end
end
