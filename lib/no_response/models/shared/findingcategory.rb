# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # FindingCategory - What a finding is about: a direct threat to the principal or the group, intent to harm without a named target, fixation on the principal, a grievance against the host, research into the venue, route or security, weapons tied to any of these, disruption or protest planning toward this group, violent extremist content or identification, prior harassment or stalking of staff or principals, or posting the principal's addresses or movements.
      class FindingCategory
        include ::Crystalline::Enum
        enums do
          DIRECT_THREAT = new("direct_threat")
          HARM_INTENT = new("harm_intent")
          FIXATION = new("fixation")
          GRIEVANCE = new("grievance")
          SECURITY_RESEARCH = new("security_research")
          WEAPONS = new("weapons")
          DISRUPTION = new("disruption")
          VIOLENT_EXTREMISM = new("violent_extremism")
          HARASSMENT = new("harassment")
          MOVEMENT_EXPOSURE = new("movement_exposure")
        end

        open!
      end
    end
  end
end
