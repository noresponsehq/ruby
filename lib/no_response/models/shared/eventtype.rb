# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class EventType
        include ::Crystalline::Enum
        enums do
          ASSESSMENT_UPDATED = new("assessment.updated")
        end

        open!
      end
    end
  end
end
