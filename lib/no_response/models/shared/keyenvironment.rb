# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # KeyEnvironment - The environment the key belongs to. A live key assesses with live sources; a test key answers from the deterministic simulator.
      class KeyEnvironment
        include ::Crystalline::Enum
        enums do
          LIVE = new("live")
          TEST = new("test")
        end

        open!
      end
    end
  end
end
