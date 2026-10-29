# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Confidence - Evidence coverage: how much of the planned source evidence gave a definite answer. This is not confidence that an identity is genuine, agreement between identifiers, a risk score or a probability. unavailable means no usable evidence answered; a terminal uncovered assessment can have this value and recommend review.
      class Confidence
        include ::Crystalline::Enum
        enums do
          LOW = new("low")
          MEDIUM = new("medium")
          HIGH = new("high")
          UNAVAILABLE = new("unavailable")
        end

        open!
      end
    end
  end
end
