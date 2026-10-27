# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The account's decision for at least one flow changed. account is the account as GET /v1/accounts/{account_id} answers it for the revision that made the change: its new score, decision, reasons and decisions_by_flow, and the assessment the risk comes from. previous_decisions_by_flow are the decisions it replaced, so account.decisions_by_flow differs from them for at least one flow, and previous_risk_version is the risk_version they were announced at. On the account's first event no decision was announced before: previous_risk_version is absent and previous_decisions_by_flow is allow for every flow, the decisions an account has before its first event. Events of one account are not ordered: account.risk_version orders them, so keep the account with the highest risk_version and ignore an event whose account is older than the one held.
      class AccountRiskChanged
        extend T::Sig
        include Crystalline::MetadataFields

        # Body of the 200 answer to GET /v1/accounts/{account_id}: the one current risk of one of the calling workspace's accounts. It is the risk of the account's latest assessment that has a decision (status complete or partial), by created_at and then assessment_id, scored exactly as GET /v1/assessments/{assessment_id} scores that assessment, plus the account's own reason shared_api_key when a key issued to the account was used from many IP addresses or countries (POST /v1/key_usage/batches). Its assessments are the account's history (GET /v1/accounts/{account_id}/assessments).
        field(
          :account,
          Models::Shared::Account,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account"), required: true}}
        )
        # The decision for each flow: the account's score under that flow's thresholds. A flow the workspace has not set uses its account_creation thresholds, so the flows differ only where it set them. The flow of the current assessment is held while that flow's admission is held and the assessment's investigation has not completed.
        field(
          :previous_decisions_by_flow,
          Models::Shared::AccountDecisionsByFlow,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("previous_decisions_by_flow"), required: true}}
        )
        # The account's risk_version when previous_decisions_by_flow were announced, always lower than account.risk_version. Absent on the account's first event, when no decision was announced before, and on the first event after the account was deleted.
        field(
          :previous_risk_version,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("previous_risk_version")}}
        )

        sig {
          params(
            account: Models::Shared::Account,
            previous_decisions_by_flow: Models::Shared::AccountDecisionsByFlow,
            previous_risk_version: T.nilable(::Integer)
          )
            .void
        }
        def initialize(account:, previous_decisions_by_flow:, previous_risk_version: nil)
          @account = account
          @previous_decisions_by_flow = previous_decisions_by_flow
          @previous_risk_version = previous_risk_version
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account == other.account
          return false unless @previous_decisions_by_flow == other.previous_decisions_by_flow
          return false unless @previous_risk_version == other.previous_risk_version
          true
        end
      end
    end
  end
end
