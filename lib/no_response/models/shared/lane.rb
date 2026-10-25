# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Lane - An evidence lane: accounts (account presence for email and username), phone, breach, domain (the email domain's registration) and ip.
      class Lane
        include ::Crystalline::Enum
        enums do
          ACCOUNTS = new("accounts")
          PHONE = new("phone")
          BREACH = new("breach")
          DOMAIN = new("domain")
          IP = new("ip")
        end

        open!
      end
    end
  end
end
