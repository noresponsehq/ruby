# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ListPeopleRole < T::Enum
        enums do
          GUEST = new("guest")
          CREW = new("crew")
          VENDOR = new("vendor")
          PRESS = new("press")
          UNSTATED = new("unstated")
        end
      end
    end
  end
end
