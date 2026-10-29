# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Impact - The selected reason's served impact band. Requires reason.
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
