# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyEvaluationStatus
        include ::Crystalline::Enum
        enums do
          QUEUED = new("queued")
          RUNNING = new("running")
          COMPLETED = new("completed")
          FAILED = new("failed")
          CANCELLED = new("cancelled")
        end

        open!
      end
    end
  end
end
