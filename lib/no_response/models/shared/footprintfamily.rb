# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # FootprintFamily - The source-neutral kind of evidence: account_presence (an account found on a site), auth_provider (the account at your auth provider), breach (breach and credential tables), breach_abuse (abuse and fraud communities' tables) and code_hosting (a code hosting profile).
      class FootprintFamily
        include ::Crystalline::Enum
        enums do
          ACCOUNT_PRESENCE = new("account_presence")
          AUTH_PROVIDER = new("auth_provider")
          BREACH = new("breach")
          BREACH_ABUSE = new("breach_abuse")
          CODE_HOSTING = new("code_hosting")
        end

        open!
      end
    end
  end
end
