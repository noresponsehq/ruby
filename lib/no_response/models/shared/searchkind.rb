# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # SearchKind - The kind of the value searched. A domain search finds the leaked rows of every email address at the domain.
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
          DOMAIN = new("domain")
        end

        open!
      end
    end
  end
end
