# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListLinkedAccountsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The account_id the workspace sends with its assessments, as one path segment (percent-encode '|' and ':' if the client requires it). A value that does not match the account_id shape answers 400 invalid_request.
        field :account_id, ::String, {'path_param': {'field_name': "account_id", 'style': "simple", 'explode': false}}
        # next_cursor from the previous page, unchanged.
        field(
          :cursor,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "cursor", 'style': "form", 'explode': true}}
        )
        # Linked accounts per page.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig { params(account_id: ::String, cursor: T.nilable(::String), limit: T.nilable(::Integer)).void }
        def initialize(account_id:, cursor: nil, limit: 25)
          @account_id = account_id
          @cursor = cursor
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @cursor == other.cursor
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
