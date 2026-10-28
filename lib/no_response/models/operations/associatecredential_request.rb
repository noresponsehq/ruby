# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class AssociateCredentialRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The account_id the workspace sends with its assessments, as one path segment (percent-encode '|' and ':' if the client requires it). A value that does not match the account_id shape answers 400 invalid_request.
        field :account_id, ::String, {'path_param': {'field_name': "account_id", 'style': "simple", 'explode': false}}

        field :body, Models::Shared::CredentialRequest, {'request': {'media_type': "application/json"}}

        sig { params(account_id: ::String, body: Models::Shared::CredentialRequest).void }
        def initialize(account_id:, body:)
          @account_id = account_id
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
