# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class WaitingFor
        include ::Crystalline::Enum
        enums do
          OUTCOME = new("outcome")
          REVIEW = new("review")
        end

        open!
      end
    end
  end
end
