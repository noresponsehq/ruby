# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # EnforcementStatus - applied when the identity provider accepted the action, failed when it refused it or could not be reached. Only applied counts as enforced.
      class EnforcementStatus
        include ::Crystalline::Enum
        enums do
          APPLIED = new("applied")
          FAILED = new("failed")
        end

        open!
      end
    end
  end
end
