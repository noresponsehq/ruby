# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Priority
        include ::Crystalline::Enum
        enums do
          LOW = new("low")
          NORMAL = new("normal")
          HIGH = new("high")
          URGENT = new("urgent")
        end

        open!
      end
    end
  end
end
