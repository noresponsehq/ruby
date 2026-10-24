# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The decision for each flow: the account's score under that flow's thresholds. A flow the workspace has not set uses its account_creation thresholds, so the flows differ only where it set them. The flow of the current assessment is held while that flow's admission is held and the assessment's investigation has not completed.
      class AccountDecisionsByFlow
        extend T::Sig
        include Crystalline::MetadataFields

        # block when the score reached your block threshold (risk.block of the assessment), otherwise the assessment's recommendation. held only for a flow whose admission is held (settings flows.<flow>.admission), when the account's current assessment was made for that flow and its investigation has not completed (status partial): the final decision arrives as account.risk_changed when the investigation completes, decided by its score, or when the hold's deadline (hold_seconds after the assessment was created) passes first, as the flow's on_expiry action or the decision the evidence so far gives, whichever is stricter. Your application applies it.
        field(
          :account_creation,
          Models::Shared::AccountDecision,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("account_creation"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AccountDecision, false)
            }
          }
        )
        # block when the score reached your block threshold (risk.block of the assessment), otherwise the assessment's recommendation. held only for a flow whose admission is held (settings flows.<flow>.admission), when the account's current assessment was made for that flow and its investigation has not completed (status partial): the final decision arrives as account.risk_changed when the investigation completes, decided by its score, or when the hold's deadline (hold_seconds after the assessment was created) passes first, as the flow's on_expiry action or the decision the evidence so far gives, whichever is stricter. Your application applies it.
        field(
          :login,
          Models::Shared::AccountDecision,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("login"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AccountDecision, false)
            }
          }
        )
        # block when the score reached your block threshold (risk.block of the assessment), otherwise the assessment's recommendation. held only for a flow whose admission is held (settings flows.<flow>.admission), when the account's current assessment was made for that flow and its investigation has not completed (status partial): the final decision arrives as account.risk_changed when the investigation completes, decided by its score, or when the hold's deadline (hold_seconds after the assessment was created) passes first, as the flow's on_expiry action or the decision the evidence so far gives, whichever is stricter. Your application applies it.
        field(
          :purchase,
          Models::Shared::AccountDecision,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("purchase"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AccountDecision, false)
            }
          }
        )

        sig {
          params(
            account_creation: Models::Shared::AccountDecision,
            login: Models::Shared::AccountDecision,
            purchase: Models::Shared::AccountDecision
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
