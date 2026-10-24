# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # EnforcementAction - What the workspace did in its identity provider: revoke_sessions (signed the account out everywhere), restrict (limited what the account can do), unrestrict (lifted an earlier restriction), fail_onboarding (stopped an account that was still onboarding), reject_activation (refused to activate a provisional account) or none (decided to take no action).
      class EnforcementAction
        include ::Crystalline::Enum
        enums do
          REVOKE_SESSIONS = new("revoke_sessions")
          RESTRICT = new("restrict")
          UNRESTRICT = new("unrestrict")
          FAIL_ONBOARDING = new("fail_onboarding")
          REJECT_ACTIVATION = new("reject_activation")
          NONE = new("none")
        end

        open!
      end
    end
  end
end
