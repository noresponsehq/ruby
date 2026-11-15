# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class InvestigationCompletedStatus < T::Enum
        enums do
          COMPLETED = new("completed")
          PARTIAL = new("partial")
          FAILED = new("failed")
          CANCELLED = new("cancelled")
        end
      end
    end
  end
end
