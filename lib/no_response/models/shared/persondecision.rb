# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PersonDecision
        include ::Crystalline::Enum
        enums do
          CLEARED = new("cleared")
          WATCH = new("watch")
          ESCALATED = new("escalated")
        end

        open!
      end
    end
  end
end
