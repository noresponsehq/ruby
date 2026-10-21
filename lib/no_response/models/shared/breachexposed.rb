# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # BreachExposed - The kind of data a breach table held beside the identifier. password means a plaintext password was present and password_hash means a hash, salt or token was present. The value itself is not stored or returned; the schema has no member for one.
      class BreachExposed
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          USERNAME = new("username")
          NAME = new("name")
          PASSWORD = new("password")
          PASSWORD_HASH = new("password_hash")
          PHONE = new("phone")
          ADDRESS = new("address")
          DOB = new("dob")
          IP = new("ip")
          PAYMENT = new("payment")
          SECURITY_QA = new("security_qa")
        end

        open!
      end
    end
  end
end
