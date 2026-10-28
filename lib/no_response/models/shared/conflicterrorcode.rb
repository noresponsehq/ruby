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
          LIST_ENTRY_EXISTS = new("list_entry_exists")
          LIST_LIMIT_REACHED = new("list_limit_reached")
          LIST_ENTRY_TOO_BROAD = new("list_entry_too_broad")
        end

        open!
      end
    end
  end
end
