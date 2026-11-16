# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Certainty - confirmed: a linked record or the searched identifier states it directly. likely: a strong inference. possible: a weak inference.
      class Certainty
        include ::Crystalline::Enum
        enums do
          CONFIRMED = new("confirmed")
          LIKELY = new("likely")
          POSSIBLE = new("possible")
        end

        open!
      end
    end
  end
end
