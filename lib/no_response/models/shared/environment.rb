# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Environment - The environment whose endpoints receive this event: live, or test for the workspace's test environment.
      class Environment < T::Enum
        enums do
          LIVE = new("live")
          TEST = new("test")
        end
      end
    end
  end
end
