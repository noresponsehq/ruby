# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # BreachSelector - The submitted identifier a breach table matched on: email or username. Phone and name are not breach selectors.
      class BreachSelector
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          USERNAME = new("username")
          IP = new("ip")
        end

        open!
      end
    end
  end
end
