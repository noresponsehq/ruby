# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # PersonBatchItemOutcome - unchanged: the row matched a person with the same details.
      class PersonBatchItemOutcome
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
