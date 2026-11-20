# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ProfileMatchState - How sure the screening is that a profile is the person's, from the likelihood its record scores. Confirmed reaches the join bar of 0.9. Probable reaches 0.85, which takes a shared value beyond the one that found the account. Possible is the rest.
      class ProfileMatchState
        include ::Crystalline::Enum
        enums do
          CONFIRMED = new("confirmed")
          PROBABLE = new("probable")
          POSSIBLE = new("possible")
        end

        open!
      end
    end
  end
end
