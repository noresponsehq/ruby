# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # BreachSelector - The submitted email or username whose own search matched the table. A submitted full name is searched as well, and what it finds feeds the identity's reasons rather than this list.
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
