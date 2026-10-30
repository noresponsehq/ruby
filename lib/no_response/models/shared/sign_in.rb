# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class SignIn
        include ::Crystalline::Enum
        enums do
          PASSWORD = new("password")
          GOOGLE = new("google")
          FACEBOOK = new("facebook")
          APPLE = new("apple")
          MICROSOFT = new("microsoft")
          SSO = new("sso")
          OTHER = new("other")
        end

        open!
      end
    end
  end
end
