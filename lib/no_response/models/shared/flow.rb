# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Flow - The customer event an assessment is made for: signup (a new account), login (a returning sign-in) or purchase (a payment or credit grant). The account's risk is reported with the decision for this flow.
      class Flow
        include ::Crystalline::Enum
        enums do
          SIGNUP = new("signup")
          LOGIN = new("login")
          PURCHASE = new("purchase")
        end

        open!
      end
    end
  end
end
