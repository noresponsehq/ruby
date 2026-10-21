# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AuthenticationErrorCode - Machine codes an HTTP 401 answer can carry.
      class AuthenticationErrorCode
        include ::Crystalline::Enum
        enums do
          UNAUTHORIZED = new("unauthorized")
        end

        open!
      end
    end
  end
end
