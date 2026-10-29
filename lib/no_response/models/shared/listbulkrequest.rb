# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # At most 100 additions and removals combined. One transaction applies all changes or none. Idempotency-Key prevents duplicate changes for 24 hours; a different body under the same key returns 409. Matching reads see the new list immediately, while bounded durable jobs propagate account risk notifications.
      class ListBulkRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :add,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::ListEntryRequest)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("add")}}
        )

        field(
          :remove,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("remove")}}
        )

        sig {
          params(add: T.nilable(T::Array[Models::Shared::ListEntryRequest]), remove: T.nilable(T::Array[::String])).void
        }
        def initialize(add: nil, remove: nil)
          @add = add
          @remove = remove
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @add == other.add
          return false unless @remove == other.remove
          true
        end
      end
    end
  end
end
