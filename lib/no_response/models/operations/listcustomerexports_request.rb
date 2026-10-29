# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListCustomerExportsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.
        field(
          :workspace_id,
          ::String,
          {'path_param': {'field_name': "workspace_id", 'style': "simple", 'explode': false}}
        )

        field(
          :kind,
          Models::Shared::CustomerExportRequestKind,
          {'query_param': {'field_name': "kind", 'style': "form", 'explode': true}}
        )

        field(
          :environment,
          Models::Shared::Environment,
          {'query_param': {'field_name': "environment", 'style': "form", 'explode': true}}
        )

        field(
          :cursor,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "cursor", 'style': "form", 'explode': true}}
        )

        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig {
          params(
            workspace_id: ::String,
            kind: Models::Shared::CustomerExportRequestKind,
            environment: Models::Shared::Environment,
            cursor: T.nilable(::String),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(workspace_id:, kind:, environment:, cursor: nil, limit: 25)
          @workspace_id = workspace_id
          @kind = kind
          @environment = environment
          @cursor = cursor
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @kind == other.kind
          return false unless @environment == other.environment
          return false unless @cursor == other.cursor
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
