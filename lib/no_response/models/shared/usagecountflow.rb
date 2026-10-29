# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # UsageCountFlow - assessments only.
      class UsageCountFlow
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
