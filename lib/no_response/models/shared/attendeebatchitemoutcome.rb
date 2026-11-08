# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AttendeeBatchItemOutcome - unchanged: the row matched an attendee with the same details.
      class AttendeeBatchItemOutcome
        include ::Crystalline::Enum
        enums do
          CREATED = new("created")
          UPDATED = new("updated")
          UNCHANGED = new("unchanged")
        end

        open!
      end
    end
  end
end
