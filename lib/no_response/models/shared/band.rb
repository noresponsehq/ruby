# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Band - low 0-29, medium 30-59, high 60-84, critical 85-100.
      class Band
        include ::Crystalline::Enum
        enums do
          LOW = new("low")
          MEDIUM = new("medium")
          HIGH = new("high")
          CRITICAL = new("critical")
        end

        open!
      end
    end
  end
end
