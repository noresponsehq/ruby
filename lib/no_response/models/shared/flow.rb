# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Flow - The provider flow the assessment gates. Absent means signup.
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
