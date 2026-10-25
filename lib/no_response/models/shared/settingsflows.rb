# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class SettingsFlows
        extend T::Sig
        include Crystalline::MetadataFields

        # One flow's policy in force. A score below step_up is allow, below review step_up, and from review review; from block, when present, the decision is block. admission says when the flow's decision is final.
        field(
          :account_creation,
          Models::Shared::FlowSettings,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_creation"), required: true}}
        )
        # One flow's policy in force. A score below step_up is allow, below review step_up, and from review review; from block, when present, the decision is block. admission says when the flow's decision is final.
        field(
          :login,
          Models::Shared::FlowSettings,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("login"), required: true}}
        )
        # One flow's policy in force. A score below step_up is allow, below review step_up, and from review review; from block, when present, the decision is block. admission says when the flow's decision is final.
        field(
          :purchase,
          Models::Shared::FlowSettings,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("purchase"), required: true}}
        )

        sig {
          params(
            account_creation: Models::Shared::FlowSettings,
            login: Models::Shared::FlowSettings,
            purchase: Models::Shared::FlowSettings
          )
            .void
        }
        def initialize(account_creation:, login:, purchase:)
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
