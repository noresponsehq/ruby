# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class CustomerExportStatus
        include ::Crystalline::Enum
        enums do
          QUEUED = new("queued")
          RUNNING = new("running")
          COMPLETED = new("completed")
          FAILED = new("failed")
          CANCELLED = new("cancelled")
          EXPIRED = new("expired")
        end

        open!
      end
    end
  end
end
