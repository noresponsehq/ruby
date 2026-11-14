# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # PersonRole - The person's role in the group: guest (a ticket holder), crew, vendor or press. Leave it out when you do not know it: a person without one has no role, not guest. A later row naming the same person replaces it, and a change of role alone keeps the person's screening results.
      class PersonRole
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
