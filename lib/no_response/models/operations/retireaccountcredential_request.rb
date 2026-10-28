# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class RetireAccountCredentialRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The account_id the workspace sends with its assessments, as one path segment (percent-encode '|' and ':' if the client requires it). A value that does not match the account_id shape answers 400 invalid_request.
        field :account_id, ::String, {'path_param': {'field_name': "account_id", 'style': "simple", 'explode': false}}

        field(
          :credential_id,
          ::String,
          {'path_param': {'field_name': "credential_id", 'style': "simple", 'explode': false}}
        )

        sig { params(account_id: ::String, credential_id: ::String).void }
        def initialize(account_id:, credential_id:)
          @account_id = account_id
          @credential_id = credential_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @credential_id == other.credential_id
          true
        end
      end
    end
  end
end
