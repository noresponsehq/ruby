# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The answer of POST /v1/accounts/{account_id}/enforcements: one enforcement of one of the calling workspace's accounts, kept once per (account, risk_version, flow, action). The first report answers 201 with the new record. A repeat answers 200 with the record as first stored, whatever the repeat's state_before, status, provider or error_code. The one exception is a stored failed record followed by an applied report: the record becomes applied, keeps its id and created_at, takes the applied report's state_before and provider, drops error_code and answers 201, so a successful retry after a failure is recorded. Only an applied record at the account's current risk_version takes the account out of GET /v1/accounts?unenforced=true.
      class Enforcement
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned id of one recorded enforcement: 'enf_' and 26 Crockford base32 characters. Unique within the workspace.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # The account_id of the request path.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )
        # The account's risk_version the workspace acted on. It can be older than the account's current risk_version: such a record is kept and does not count for unenforced.
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
        # What the workspace did in its identity provider: revoke_sessions (signed the account out everywhere), restrict (limited what the account can do), unrestrict (lifted an earlier restriction), fail_onboarding (stopped an account that was still onboarding), reject_activation (refused to activate a provisional account), activate (let a held onboarding or provisional account in) or none (decided to take no action).
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
        # When NoResponse first recorded this enforcement, in UTC. A failed record that becomes applied keeps it.
        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # Why a failed action failed, as a short code of the workspace's choosing (lower-case letters, digits, '_', '.' and '-'), such as the identity provider's error code. Allowed only with status failed: with status applied it answers 400 invalid_request. Keep personal data out of it.
        field(
          :error_code,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("error_code")}}
        )

        sig {
          params(
            id: ::String,
            account_id: ::String,
            risk_version: ::Integer,
            flow: Models::Shared::Flow,
            action: Models::Shared::EnforcementAction,
            state_before: Models::Shared::EnforcementState,
            status: Models::Shared::EnforcementStatus,
            provider: Models::Shared::EnforcementProvider,
            created_at: ::String,
            error_code: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          account_id:,
          risk_version:,
          flow:,
          action:,
          state_before:,
          status:,
          provider:,
          created_at:,
          error_code: nil
        )
          @id = id
          @account_id = account_id
          @risk_version = risk_version
          @flow = flow
          @action = action
          @state_before = state_before
          @status = status
          @provider = provider
          @created_at = created_at
          @error_code = error_code
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @account_id == other.account_id
          return false unless @risk_version == other.risk_version
          return false unless @flow == other.flow
          return false unless @action == other.action
          return false unless @state_before == other.state_before
          return false unless @status == other.status
          return false unless @provider == other.provider
          return false unless @created_at == other.created_at
          return false unless @error_code == other.error_code
          true
        end
      end
    end
  end
end
