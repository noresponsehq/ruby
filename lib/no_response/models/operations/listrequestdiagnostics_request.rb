# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListRequestDiagnosticsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Inclusive start of a range of at most seven days.
        field :from, ::String, {'query_param': {'field_name': "from", 'style': "form", 'explode': true}}
        # Exclusive end of the range.
        field :to, ::String, {'query_param': {'field_name': "to", 'style': "form", 'explode': true}}
        # Optional filter or paging parameter.
        field(
          :request_id,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "request_id", 'style': "form", 'explode': true}}
        )
        # Optional filter or paging parameter.
        field(
          :route,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "route", 'style': "form", 'explode': true}}
        )
        # Optional filter or paging parameter.
        field(
          :status,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "status", 'style': "form", 'explode': true}}
        )
        # Optional filter or paging parameter.
        field(
          :cursor,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "cursor", 'style': "form", 'explode': true}}
        )
        # Filter by the public authenticated API key identifier; older unattributed rows do not match.
        field(
          :api_key_id,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "api_key_id", 'style': "form", 'explode': true}}
        )
        # Optional filter or paging parameter.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig {
          params(
            from: ::String,
            to: ::String,
            request_id: T.nilable(::String),
            route: T.nilable(::String),
            status: T.nilable(::Integer),
            cursor: T.nilable(::String),
            api_key_id: T.nilable(::String),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(from:, to:, request_id: nil, route: nil, status: nil, cursor: nil, api_key_id: nil, limit: 50)
          @from = from
          @to = to
          @request_id = request_id
          @route = route
          @status = status
          @cursor = cursor
          @api_key_id = api_key_id
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @request_id == other.request_id
          return false unless @route == other.route
          return false unless @status == other.status
          return false unless @cursor == other.cursor
          return false unless @api_key_id == other.api_key_id
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
