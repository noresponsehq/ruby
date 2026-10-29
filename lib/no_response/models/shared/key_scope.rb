# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class KeyScope
        include ::Crystalline::Enum
        enums do
          ASSESS = new("assess")
          HISTORY = new("history")
          DELETE = new("delete")
          WEBHOOKS = new("webhooks")
          DETAILED = new("detailed")
          INTEGRATIONS = new("integrations")
          MANAGEMENT = new("management")
          AUDIT = new("audit")
          USAGE = new("usage")
          INVESTIGATE = new("investigate")
          EVIDENCE = new("evidence")
          EXPORTS = new("exports")
          AUDIT_MANAGE = new("audit_manage")
          SETTINGS = new("settings")
          POLICY_PUBLISH = new("policy_publish")
          MEMBERS = new("members")
          MEMBERS_MANAGE = new("members_manage")
        end

        open!
      end
    end
  end
end
