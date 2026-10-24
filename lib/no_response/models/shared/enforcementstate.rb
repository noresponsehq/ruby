# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # EnforcementState - The account's state in the workspace's identity provider just before the action: onboarding, provisional (created, not yet activated), active, restricted or rejected.
      class EnforcementState
        include ::Crystalline::Enum
        enums do
          ONBOARDING = new("onboarding")
          PROVISIONAL = new("provisional")
          ACTIVE = new("active")
          RESTRICTED = new("restricted")
          REJECTED = new("rejected")
        end

        open!
      end
    end
  end
end
