# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Significance - One rule ranks every change: identity changes (accounts, breaches, identifiers) are high, profile fields are medium, new posts are low.
      class Significance
        include ::Crystalline::Enum
        enums do
          HIGH = new("high")
          MEDIUM = new("medium")
          LOW = new("low")
        end

        open!
      end
    end
  end
end
