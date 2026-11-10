# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ScreeningStatus - partial finished with some attendees or platforms not covered; attendees_failed and attendees_partial count them.
      class ScreeningStatus
        include ::Crystalline::Enum
        enums do
          QUEUED = new("queued")
          RUNNING = new("running")
          COMPLETED = new("completed")
          PARTIAL = new("partial")
          FAILED = new("failed")
          CANCELLED = new("cancelled")
        end

        open!
      end
    end
  end
end
