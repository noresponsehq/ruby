# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Flow - The provider flow the assessment gates. Use the top-level flow instead; this member is ignored when the top-level flow is present. Absent means signup.
      class Flow < T::Enum
        enums do
          SIGNUP = new("signup")
          LOGIN = new("login")
          RECOVERY = new("recovery")
          PROFILE_CHANGE = new("profile_change")
        end
      end
    end
  end
end
