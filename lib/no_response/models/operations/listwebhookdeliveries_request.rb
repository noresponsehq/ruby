# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListWebhookDeliveriesRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The endpoint's whe_ id. An id that is unknown, malformed or another workspace's answers 404.
        field :endpoint_id, ::String, {'path_param': {'field_name': "endpoint_id", 'style': "simple", 'explode': false}}
        # next_cursor from the previous page, unchanged.
        field(
          :cursor,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "cursor", 'style': "form", 'explode': true}}
        )
        # Attempts per page.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig { params(endpoint_id: ::String, cursor: T.nilable(::String), limit: T.nilable(::Integer)).void }
        def initialize(endpoint_id:, cursor: nil, limit: 20)
          @endpoint_id = endpoint_id
          @cursor = cursor
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint_id == other.endpoint_id
          return false unless @cursor == other.cursor
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
