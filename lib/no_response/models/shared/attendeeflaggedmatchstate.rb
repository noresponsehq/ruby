# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AttendeeFlaggedMatchState - How sure the screening is that the accounts it read are the attendee's. A finding on a possible match is at most moderate, on a probable match at most high.
      class AttendeeFlaggedMatchState < T::Enum
        enums do
          CONFIRMED = new("confirmed")
          PROBABLE = new("probable")
          POSSIBLE = new("possible")
          NONE_FOUND = new("none_found")
          INACCESSIBLE = new("inaccessible")
        end
      end
    end
  end
end
