# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/accounts/{account_id}/enforcements body: what the workspace did to the account in its identity provider after reading the account's risk at risk_version. The account is named by the path and the workspace by the API key, so neither is a body member. An enforcement is the workspace's own action, not an outcome: what the workspace later learned about an assessment goes to POST /v1/assessments/{assessment_id}/outcomes. The record's key is (account, risk_version, flow, action), so a retry of the same report is safe and needs no Idempotency-Key.
      class EnforcementRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The account's risk_version the workspace acted on, as read from GET /v1/accounts/{account_id}, GET /v1/accounts, an assessment answer or account.risk_changed. A version older than the account's current one is accepted and stored; a version newer than the current one answers 409 risk_version_ahead.
        field(
          :risk_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("risk_version"), required: true}}
        )
        # The event an assessment is made for: account_creation (a user creates an account), login (a user returns to an existing account) or purchase (a payment or a credit grant). The account's risk is reported with the decision for this flow.
        field(
          :flow,
          Models::Shared::Flow,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("flow"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Flow, false)
            }
          }
        )
        # What the workspace did in its identity provider: revoke_sessions (signed the account out everywhere), restrict (limited what the account can do), unrestrict (lifted an earlier restriction), fail_onboarding (stopped an account that was still onboarding), reject_activation (refused to activate a provisional account) or none (decided to take no action).
        field(
          :action,
          Models::Shared::EnforcementAction,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("action"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::EnforcementAction, false)
            }
          }
        )
        # The account's state in the workspace's identity provider just before the action: onboarding, provisional (created, not yet activated), active, restricted or rejected.
        field(
          :state_before,
          Models::Shared::EnforcementState,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("state_before"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::EnforcementState, false)
            }
          }
        )
        # applied when the identity provider accepted the action, failed when it refused it or could not be reached. Only applied counts as enforced.
        field(
          :status,
          Models::Shared::EnforcementStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::EnforcementStatus, false)
            }
          }
        )
        # The identity provider the action ran in; custom for the workspace's own user store.
        field(
          :provider,
          Models::Shared::EnforcementProvider,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("provider"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::EnforcementProvider, false)
            }
          }
        )
        # Why a failed action failed, as a short code of the workspace's choosing (lower-case letters, digits, '_', '.' and '-'), such as the identity provider's error code. Allowed only with status failed: with status applied it answers 400 invalid_request. Keep personal data out of it.
        field(
          :error_code,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("error_code")}}
        )

        sig {
          params(
            risk_version: ::Integer,
            flow: Models::Shared::Flow,
            action: Models::Shared::EnforcementAction,
            state_before: Models::Shared::EnforcementState,
            status: Models::Shared::EnforcementStatus,
            provider: Models::Shared::EnforcementProvider,
            error_code: T.nilable(::String)
          )
            .void
        }
        def initialize(risk_version:, flow:, action:, state_before:, status:, provider:, error_code: nil)
          @risk_version = risk_version
          @flow = flow
          @action = action
          @state_before = state_before
          @status = status
          @provider = provider
          @error_code = error_code
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @risk_version == other.risk_version
          return false unless @flow == other.flow
          return false unless @action == other.action
          return false unless @state_before == other.state_before
          return false unless @status == other.status
          return false unless @provider == other.provider
          return false unless @error_code == other.error_code
          true
        end
      end
    end
  end
end
