# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # HookPoint - The provider event a provider_hook context was sent for. pre_registration runs before the user exists, so subject and the request's account_id may be absent there. Sent only with transport provider_hook.
      class HookPoint < T::Enum
        enums do
          PRE_REGISTRATION = new("pre_registration")
          POST_REGISTRATION = new("post_registration")
          PRE_LOGIN = new("pre_login")
          POST_LOGIN = new("post_login")
          TOKEN_ISSUANCE = new("token_issuance")
        end
      end
    end
  end
end
