# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # RiskConfidence - How much of the planned evidence answered; it says nothing about risk.
      class RiskConfidence
        include ::Crystalline::Enum
        enums do
          LOW = new("low")
          MEDIUM = new("medium")
          HIGH = new("high")
        end

        open!
      end
    end
  end
end
