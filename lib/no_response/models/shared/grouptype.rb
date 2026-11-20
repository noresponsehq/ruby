# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # GroupType - What the group's people share: an event, an organisation, a place or another attribute.
      class GroupType
        include ::Crystalline::Enum
        enums do
          EVENT = new("event")
          ORGANISATION = new("organisation")
          PLACE = new("place")
          CUSTOM = new("custom")
        end

        open!
      end
    end
  end
end
