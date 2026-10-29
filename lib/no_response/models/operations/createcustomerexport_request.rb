# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class CreateCustomerExportRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.
        field(
          :workspace_id,
          ::String,
          {'path_param': {'field_name': "workspace_id", 'style': "simple", 'explode': false}}
        )

        field :body, Models::Shared::CustomerExportRequest, {'request': {'media_type': "application/json"}}

        field(
          :idempotency_key,
          Crystalline::Nilable.new(::String),
          {'header': {'field_name': "Idempotency-Key", 'style': "simple", 'explode': false}}
        )

        sig {
          params(
            workspace_id: ::String,
            body: Models::Shared::CustomerExportRequest,
            idempotency_key: T.nilable(::String)
          )
            .void
        }
        def initialize(workspace_id:, body:, idempotency_key: nil)
          @workspace_id = workspace_id
          @body = body
          @idempotency_key = idempotency_key
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @body == other.body
          return false unless @idempotency_key == other.idempotency_key
          true
        end
      end
    end
  end
end
