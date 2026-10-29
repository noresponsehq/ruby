# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AuditEventTargetType - The kind of resource the change acted on.
      class AuditEventTargetType
        include ::Crystalline::Enum
        enums do
          WORKSPACE = new("workspace")
          MEMBER = new("member")
          INVITE = new("invite")
          KEY = new("key")
          SETTING = new("setting")
          WEBHOOK_ENDPOINT = new("webhook_endpoint")
          INTEGRATION = new("integration")
          BILLING = new("billing")
          REVIEW = new("review")
        end

        open!
      end
    end
  end
end
