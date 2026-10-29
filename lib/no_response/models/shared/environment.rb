# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Environment
        include ::Crystalline::Enum
        enums do
          LIVE = new("live")
          TEST = new("test")
          WORKSPACE = new("workspace")
        end

        open!
      end
    end
  end
end
