# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # IntegrationHookPoint - pre_registration runs before the user exists; post_login runs after a successful sign-in.
      class IntegrationHookPoint
        include ::Crystalline::Enum
        enums do
          PRE_REGISTRATION = new("pre_registration")
          POST_LOGIN = new("post_login")
        end

        open!
      end
    end
  end
end
