# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # OwnerType - The credential namespace of the creator. An external user ID equal to an API-key label does not grant ownership of that key's private view.
      class OwnerType
        include ::Crystalline::Enum
        enums do
          USER = new("user")
          API_KEY = new("api_key")
        end

        open!
      end
    end
  end
end
