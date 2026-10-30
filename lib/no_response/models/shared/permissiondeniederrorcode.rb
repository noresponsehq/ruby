# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # PermissionDeniedErrorCode - Machine codes an HTTP 403 answer can carry.
      class PermissionDeniedErrorCode
        include ::Crystalline::Enum
        enums do
          WORKSPACE_FORBIDDEN = new("workspace_forbidden")
          ROLE_FORBIDDEN = new("role_forbidden")
          EMAIL_UNVERIFIED = new("email_unverified")
          ONBOARDING_IN_REVIEW = new("onboarding_in_review")
          ONBOARDING_REFUSED = new("onboarding_refused")
        end

        open!
      end
    end
  end
end
