# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # SearchKind - The kind of the value searched.
      class SearchKind
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          PHONE = new("phone")
          USERNAME = new("username")
          PERSON_NAME = new("person_name")
          PASSWORD = new("password")
          HASH = new("hash")
          IP = new("ip")
        end

        open!
      end
    end
  end
end
