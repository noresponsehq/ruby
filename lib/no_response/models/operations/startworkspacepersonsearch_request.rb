# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class StartWorkspacePersonSearchRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :person_id, ::String, {'path_param': {'field_name': "person_id", 'style': "simple", 'explode': false}}

        field :body, Models::Shared::SearchRequest, {'request': {'media_type': "application/json"}}
        # Opaque request key, 16 to 128 characters. Repeating the key and request returns the same resource in its current state while it is retained. A different request with the same key answers 409. Use a new key for a deliberate new operation. Keys are scoped to the environment and operation; person searches also scope them to the group and person.
        field(
          :idempotency_key,
          Crystalline::Nilable.new(::String),
          {'header': {'field_name': "Idempotency-Key", 'style': "simple", 'explode': false}}
        )

        sig {
          params(person_id: ::String, body: Models::Shared::SearchRequest, idempotency_key: T.nilable(::String)).void
        }
        def initialize(person_id:, body:, idempotency_key: nil)
          @person_id = person_id
          @body = body
          @idempotency_key = idempotency_key
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @person_id == other.person_id
          return false unless @body == other.body
          return false unless @idempotency_key == other.idempotency_key
          true
        end
      end
    end
  end
end
