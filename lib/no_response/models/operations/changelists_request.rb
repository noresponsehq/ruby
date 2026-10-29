# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ChangeListsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.
        field(
          :workspace_id,
          ::String,
          {'path_param': {'field_name': "workspace_id", 'style': "simple", 'explode': false}}
        )
        # The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404.
        field(
          :environment,
          Models::Shared::KeyEnvironment,
          {'path_param': {'field_name': "environment", 'style': "simple", 'explode': false}}
        )

        field :body, Models::Shared::ListBulkRequest, {'request': {'media_type': "application/json"}}
        # Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the workspace principal and bound to the canonical body for 24 hours. Optional: the SDK generates a UUID when you omit it and sends the same key on every retry of the call.
        field(
          :idempotency_key,
          Crystalline::Nilable.new(::String),
          {'header': {'field_name': "Idempotency-Key", 'style': "simple", 'explode': false}}
        )

        sig {
          params(
            workspace_id: ::String,
            environment: Models::Shared::KeyEnvironment,
            body: Models::Shared::ListBulkRequest,
            idempotency_key: T.nilable(::String)
          )
            .void
        }
        def initialize(workspace_id:, environment:, body:, idempotency_key: nil)
          @workspace_id = workspace_id
          @environment = environment
          @body = body
          @idempotency_key = idempotency_key
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @body == other.body
          return false unless @idempotency_key == other.idempotency_key
          true
        end
      end
    end
  end
end
