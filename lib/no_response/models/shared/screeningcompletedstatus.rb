# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ScreeningCompletedStatus - completed reached every person; partial left some not fully covered (partial_coverage); failed covered nobody.
      class ScreeningCompletedStatus < T::Enum
        enums do
          COMPLETED = new("completed")
          PARTIAL = new("partial")
          FAILED = new("failed")
        end
      end
    end
  end
end
