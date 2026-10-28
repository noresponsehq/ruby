# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class RecordAccountOutcomeRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The account_id the workspace sends with its assessments, as one path segment (percent-encode '|' and ':' if the client requires it). A value that does not match the account_id shape answers 400 invalid_request.
        field :account_id, ::String, {'path_param': {'field_name': "account_id", 'style': "simple", 'explode': false}}

        field :body, Models::Shared::AccountOutcomeRequest, {'request': {'media_type': "application/json"}}
        # Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the workspace principal and bound to the canonical body for 24 hours. Optional: the SDK generates a UUID when you omit it and sends the same key on every retry of the call.
        field(
          :idempotency_key,
          Crystalline::Nilable.new(::String),
          {'header': {'field_name': "Idempotency-Key", 'style': "simple", 'explode': false}}
        )

        sig {
          params(
            account_id: ::String,
            body: Models::Shared::AccountOutcomeRequest,
            idempotency_key: T.nilable(::String)
          )
            .void
        }
        def initialize(account_id:, body:, idempotency_key: nil)
          @account_id = account_id
          @body = body
          @idempotency_key = idempotency_key
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @body == other.body
          return false unless @idempotency_key == other.idempotency_key
          true
        end
      end
    end
  end
end
