# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AccountType - personal, or business: an account a company or school manages.
      class AccountType
        include ::Crystalline::Enum
        enums do
          PERSONAL = new("personal")
          BUSINESS = new("business")
        end

        open!
      end
    end
  end
end
