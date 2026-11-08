# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # MatchState - How sure the latest screening is that it found the attendee's accounts. unscreened until a screening reaches the attendee.
      class MatchState
        include ::Crystalline::Enum
        enums do
          UNSCREENED = new("unscreened")
          CONFIRMED = new("confirmed")
          PROBABLE = new("probable")
          POSSIBLE = new("possible")
          NONE_FOUND = new("none_found")
          INACCESSIBLE = new("inaccessible")
        end

        open!
      end
    end
  end
end
