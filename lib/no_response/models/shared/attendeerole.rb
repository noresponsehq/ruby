# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AttendeeRole - The attendee's role at the event: guest (a ticket holder), crew, vendor or press. Leave it out when you do not know it: an attendee without one has no role, not guest. A later row naming the same attendee replaces it, and a change of role alone keeps the attendee's screening results.
      class AttendeeRole
        include ::Crystalline::Enum
        enums do
          GUEST = new("guest")
          CREW = new("crew")
          VENDOR = new("vendor")
          PRESS = new("press")
        end

        open!
      end
    end
  end
end
