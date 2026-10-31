# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ConflictErrorCode - Machine codes an HTTP 409 answer can carry.
      class ConflictErrorCode
        include ::Crystalline::Enum
        enums do
          IDEMPOTENCY_KEY_REUSED = new("idempotency_key_reused")
          KEY_ROTATION_IN_PROGRESS = new("key_rotation_in_progress")
          WEBHOOK_ENDPOINT_LIMIT_REACHED = new("webhook_endpoint_limit_reached")
          WEBHOOK_ENDPOINT_UNVERIFIED = new("webhook_endpoint_unverified")
          TOO_MANY_INTEGRATIONS = new("too_many_integrations")
          RISK_VERSION_AHEAD = new("risk_version_ahead")
          KEY_LIMIT_REACHED = new("key_limit_reached")
          SELF_REVOCATION = new("self_revocation")
          OUTCOME_CONFLICT = new("outcome_conflict")
          CREDENTIAL_CONFLICT = new("credential_conflict")
          BINDING_CONFLICT = new("binding_conflict")
          LIST_ENTRY_EXISTS = new("list_entry_exists")
          LIST_LIMIT_REACHED = new("list_limit_reached")
          LIST_ENTRY_TOO_BROAD = new("list_entry_too_broad")
          POLICY_VERSION_CONFLICT = new("policy_version_conflict")
          REVIEW_VERSION_CONFLICT = new("review_version_conflict")
          REVIEW_EXISTS = new("review_exists")
          REVIEW_LIMIT_REACHED = new("review_limit_reached")
          EXPORT_CONFLICT = new("export_conflict")
          EVALUATION_CONFLICT = new("evaluation_conflict")
          EVALUATION_NO_PROPOSAL = new("evaluation_no_proposal")
          EVALUATION_LIMIT_REACHED = new("evaluation_limit_reached")
          ALREADY_MEMBER = new("already_member")
          MEMBER_LIMIT_REACHED = new("member_limit_reached")
          OWNER_INVITE_PENDING = new("owner_invite_pending")
          AGGREGATE_ERASED_DATA = new("aggregate_erased_data")
        end

        open!
      end
    end
  end
end
