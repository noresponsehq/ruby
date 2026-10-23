# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AssessmentFlow - The customer event an assessment is made for: signup (a new account), login (a returning sign-in) or purchase (a payment or credit grant). The account's risk is reported with the decision for this flow.
      class AssessmentFlow < T::Enum
        enums do
          SIGNUP = new("signup")
          LOGIN = new("login")
          PURCHASE = new("purchase")
        end
      end
    end
  end
end
