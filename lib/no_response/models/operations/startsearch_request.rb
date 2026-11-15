# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class StartSearchRequest
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

        field :group_id, ::String, {'path_param': {'field_name': "group_id", 'style': "simple", 'explode': false}}

        field :person_id, ::String, {'path_param': {'field_name': "person_id", 'style': "simple", 'explode': false}}

        field :body, Models::Shared::SearchRequest, {'request': {'media_type': "application/json"}}
        # Opaque request key, 16 to 128 characters. Repeating the key and request returns the same resource in its current state while it is retained. A different request with the same key answers 409. Use a new key for a deliberate new operation. Keys are scoped to the environment and operation; person searches also scope them to the group and person.
        field(
          :idempotency_key,
          Crystalline::Nilable.new(::String),
          {'header': {'field_name': "Idempotency-Key", 'style': "simple", 'explode': false}}
        )

        sig {
          params(
            workspace_id: ::String,
            environment: Models::Shared::KeyEnvironment,
            group_id: ::String,
            person_id: ::String,
            body: Models::Shared::SearchRequest,
            idempotency_key: T.nilable(::String)
          )
            .void
        }
        def initialize(workspace_id:, environment:, group_id:, person_id:, body:, idempotency_key: nil)
          @workspace_id = workspace_id
          @environment = environment
          @group_id = group_id
          @person_id = person_id
          @body = body
          @idempotency_key = idempotency_key
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @group_id == other.group_id
          return false unless @person_id == other.person_id
          return false unless @body == other.body
          return false unless @idempotency_key == other.idempotency_key
          true
        end
      end
    end
  end
end
