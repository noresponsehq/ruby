# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

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
