# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class CreateAssessmentRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the tenant principal and bound to the canonical body for 24 hours.
        field(
          :idempotency_key,
          ::String,
          {'header': {'field_name': "Idempotency-Key", 'style': "simple", 'explode': false}}
        )

        field :body, Models::Shared::AssessmentRequest, {'request': {'media_type': "application/json"}}

        sig { params(idempotency_key: ::String, body: Models::Shared::AssessmentRequest).void }
        def initialize(idempotency_key:, body:)
          @idempotency_key = idempotency_key
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @idempotency_key == other.idempotency_key
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
