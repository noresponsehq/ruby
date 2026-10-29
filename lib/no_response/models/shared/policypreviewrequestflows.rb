# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyPreviewRequestFlows
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :account_creation,
          Crystalline::Nilable.new(Models::Shared::PolicyPreviewRequestFlowsAccountCreation),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_creation")}}
        )

        field(
          :login,
          Crystalline::Nilable.new(Models::Shared::PolicyPreviewRequestFlowsLogin),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("login")}}
        )

        field(
          :purchase,
          Crystalline::Nilable.new(Models::Shared::PolicyPreviewRequestFlowsPurchase),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("purchase")}}
        )

        sig {
          params(
            account_creation: T.nilable(Models::Shared::PolicyPreviewRequestFlowsAccountCreation),
            login: T.nilable(Models::Shared::PolicyPreviewRequestFlowsLogin),
            purchase: T.nilable(Models::Shared::PolicyPreviewRequestFlowsPurchase)
          )
            .void
        }
        def initialize(account_creation: nil, login: nil, purchase: nil)
          @account_creation = account_creation
          @login = login
          @purchase = purchase
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_creation == other.account_creation
          return false unless @login == other.login
          return false unless @purchase == other.purchase
          true
        end
      end
    end
  end
end
