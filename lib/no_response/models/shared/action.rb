# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Action
        include ::Crystalline::Enum
        enums do
          ALLOW = new("allow")
          BLOCK = new("block")
        end

        open!
      end
    end
  end
end
