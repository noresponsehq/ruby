# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations
      # Environment
      class Environment < T::Enum
        enums do
          TEST = new("test")
        end
      end
    end
  end
end
