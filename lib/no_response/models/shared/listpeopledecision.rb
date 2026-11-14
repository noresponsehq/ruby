# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ListPeopleDecision < T::Enum
        enums do
          CLEARED = new("cleared")
          WATCH = new("watch")
          ESCALATED = new("escalated")
          UNDECIDED = new("undecided")
        end
      end
    end
  end
end
