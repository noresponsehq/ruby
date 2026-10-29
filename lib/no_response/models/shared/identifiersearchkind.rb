# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class IdentifierSearchKind
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          PHONE = new("phone")
          USERNAME = new("username")
        end

        open!
      end
    end
  end
end
