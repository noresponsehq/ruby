# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class GetAccountDecisionRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The account_id the workspace sends with its assessments, as one path segment (percent-encode '|' and ':' if the client requires it). A value that does not match the account_id shape answers 400 invalid_request.
        field :account_id, ::String, {'path_param': {'field_name': "account_id", 'style': "simple", 'explode': false}}
        # The canonical decimal risk_version originally served.
        field(
          :risk_version,
          ::Integer,
          {'path_param': {'field_name': "risk_version", 'style': "simple", 'explode': false}}
        )

        sig { params(account_id: ::String, risk_version: ::Integer).void }
        def initialize(account_id:, risk_version:)
          @account_id = account_id
          @risk_version = risk_version
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @risk_version == other.risk_version
          true
        end
      end
    end
  end
end
