# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Flow - The event an assessment is made for: account_creation (a user creates an account), login (a user returns to an existing account) or purchase (a payment or a credit grant). The account's risk is reported with the decision for this flow.
      class Flow
        include ::Crystalline::Enum
        enums do
          ACCOUNT_CREATION = new("account_creation")
          LOGIN = new("login")
          PURCHASE = new("purchase")
        end

        open!
      end
    end
  end
end
