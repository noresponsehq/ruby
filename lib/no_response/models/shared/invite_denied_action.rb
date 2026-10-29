# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class InviteDeniedAction
        include ::Crystalline::Enum
        enums do
          EVIDENCE_READ = new("evidence.read")
          EXPORTS_READ = new("exports.read")
          POLICY_PUBLISH = new("policy.publish")
        end

        open!
      end
    end
  end
end
