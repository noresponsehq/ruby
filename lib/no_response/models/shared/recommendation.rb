# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Recommendation - The recommended action: allow, step_up or review. Your application applies it.
      class Recommendation
        include ::Crystalline::Enum
        enums do
          ALLOW = new("allow")
          STEP_UP = new("step_up")
          REVIEW = new("review")
        end

        open!
      end
    end
  end
end
