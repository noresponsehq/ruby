# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class InvestigationStatus
        include ::Crystalline::Enum
        enums do
          QUEUED = new("queued")
          RUNNING = new("running")
          COMPLETED = new("completed")
          PARTIAL = new("partial")
          FAILED = new("failed")
          CANCELLED = new("cancelled")
          UNKNOWN = new("unknown")
        end

        open!
      end
    end
  end
end
