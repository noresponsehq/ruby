# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListWorkspacePeopleRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Pass next_cursor from the prior page.
        field(
          :after,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "after", 'style': "form", 'explode': true}}
        )

        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig { params(after: T.nilable(::String), limit: T.nilable(::Integer)).void }
        def initialize(after: nil, limit: 100)
          @after = after
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @after == other.after
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
