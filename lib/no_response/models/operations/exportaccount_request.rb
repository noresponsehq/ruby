# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ExportAccountRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The account_id the workspace sends with its assessments, as one path segment (percent-encode '|' and ':' if the client requires it). A value that does not match the account_id shape answers 400 invalid_request.
        field :account_id, ::String, {'path_param': {'field_name': "account_id", 'style': "simple", 'explode': false}}
        # standard returns the consolidated risk response; detailed adds merged provider-neutral facts when the key has detailed scope. There is no raw mode.
        field(
          :response_mode,
          Crystalline::Nilable.new(Models::Shared::ResponseMode),
          {'query_param': {'field_name': "response_mode", 'style': "form", 'explode': true}}
        )

        sig { params(account_id: ::String, response_mode: T.nilable(Models::Shared::ResponseMode)).void }
        def initialize(account_id:, response_mode: nil)
          @account_id = account_id
          @response_mode = response_mode
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @response_mode == other.response_mode
          true
        end
      end
    end
  end
end
