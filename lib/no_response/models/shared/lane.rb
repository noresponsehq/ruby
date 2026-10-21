# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Lane - An evidence lane: accounts (account presence for email and username), phone, breach and ip.
      class Lane
        include ::Crystalline::Enum
        enums do
          ACCOUNTS = new("accounts")
          PHONE = new("phone")
          BREACH = new("breach")
          IP = new("ip")
        end

        open!
      end
    end
  end
end
