# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Status - Processing state, separate from evidence coverage. complete: final; nothing is still running, but unsupported, failed or unanswered lanes remain in incomplete_sources. partial: a recommendation exists and evidence is incomplete; assessment_url identifies continuing work when present. pending: no recommendation yet; poll or wait for the webhook. Finished processing does not mean all sources answered.
      class Status
        include ::Crystalline::Enum
        enums do
          COMPLETE = new("complete")
          PARTIAL = new("partial")
          PENDING = new("pending")
        end

        open!
      end
    end
  end
end
