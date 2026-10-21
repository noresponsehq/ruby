# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class CreateAssessmentRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :body, Models::Shared::AssessmentRequest, {'request': {'media_type': "application/json"}}
        # Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the tenant principal and bound to the canonical body for 24 hours. Optional: the SDK generates a UUID when you omit it and sends the same key on every retry of the call.
        field(
          :idempotency_key,
          Crystalline::Nilable.new(::String),
          {'header': {'field_name': "Idempotency-Key", 'style': "simple", 'explode': false}}
        )

        sig { params(body: Models::Shared::AssessmentRequest, idempotency_key: T.nilable(::String)).void }
        def initialize(body:, idempotency_key: nil)
          @body = body
          @idempotency_key = idempotency_key
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @body == other.body
          return false unless @idempotency_key == other.idempotency_key
          true
        end
      end
    end
  end
end
