# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ListChangeState
        include ::Crystalline::Enum
        enums do
          PROPAGATING = new("propagating")
          COMPLETED = new("completed")
        end

        open!
      end
    end
  end
end
