# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # HookPoint - The provider event a provider_hook context was sent for; absent for any other transport.
      class HookPoint
        include ::Crystalline::Enum
        enums do
          PRE_REGISTRATION = new("pre_registration")
          POST_REGISTRATION = new("post_registration")
          PRE_LOGIN = new("pre_login")
          POST_LOGIN = new("post_login")
          TOKEN_ISSUANCE = new("token_issuance")
        end

        open!
      end
    end
  end
end
