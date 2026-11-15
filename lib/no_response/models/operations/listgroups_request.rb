# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListGroupsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Read groups older than this one.
        field(
          :before,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "before", 'style': "form", 'explode': true}}
        )
        # At most this many items.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig { params(before: T.nilable(::String), limit: T.nilable(::Integer)).void }
        def initialize(before: nil, limit: 20)
          @before = before
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @before == other.before
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
