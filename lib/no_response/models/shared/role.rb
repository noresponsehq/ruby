# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Role - A built-in capability set. Specialist roles are independent; effective access is returned by GET /v1/workspaces/{workspace_id}/capabilities.
      class Role
        include ::Crystalline::Enum
        enums do
          OWNER = new("owner")
          ADMIN = new("admin")
          DEVELOPER = new("developer")
          VIEWER = new("viewer")
          INVESTIGATOR = new("investigator")
          AUDITOR = new("auditor")
          BILLING = new("billing")
        end

        open!
      end
    end
  end
end
