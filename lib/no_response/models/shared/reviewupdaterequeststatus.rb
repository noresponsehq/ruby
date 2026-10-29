# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ReviewUpdateRequestStatus < T::Enum
        enums do
          OPEN = new("open")
          IN_PROGRESS = new("in_progress")
        end
      end
    end
  end
end
