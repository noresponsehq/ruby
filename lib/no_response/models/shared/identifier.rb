# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Identifier
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          PHONE = new("phone")
          USERNAME = new("username")
          NAME = new("name")
        end

        open!
      end
    end
  end
end
