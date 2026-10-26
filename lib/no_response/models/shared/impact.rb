# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Impact
        include ::Crystalline::Enum
        enums do
          NONE = new("none")
          LOW = new("low")
          MEDIUM = new("medium")
          HIGH = new("high")
        end

        open!
      end
    end
  end
end
