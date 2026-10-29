# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AccountOutcomeActorType
        include ::Crystalline::Enum
        enums do
          API_KEY = new("api_key")
          USER = new("user")
        end

        open!
      end
    end
  end
end
