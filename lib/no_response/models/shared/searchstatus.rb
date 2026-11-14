# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # SearchStatus - A password or hash search is counting, then counted: rows says how many breach rows hold the value, and nothing runs until a person runs it (POST .../searches/{search_id}/run). Any other search is queued, then running. completed: every source it asked answered. partial: some did not. failed: none answered or none could be asked, which says nothing about whether the value is held anywhere.
      class SearchStatus
        include ::Crystalline::Enum
        enums do
          COUNTING = new("counting")
          COUNTED = new("counted")
          QUEUED = new("queued")
          RUNNING = new("running")
          COMPLETED = new("completed")
          PARTIAL = new("partial")
          FAILED = new("failed")
        end

        open!
      end
    end
  end
end
