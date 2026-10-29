# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ReviewStatus
        include ::Crystalline::Enum
        enums do
          OPEN = new("open")
          IN_PROGRESS = new("in_progress")
          RESOLVED = new("resolved")
        end

        open!
      end
    end
  end
end
