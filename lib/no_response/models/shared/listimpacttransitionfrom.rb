# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ListImpactTransitionFrom
        include ::Crystalline::Enum
        enums do
          NONE = new("none")
          ALLOW = new("allow")
          BLOCK = new("block")
        end

        open!
      end
    end
  end
end
