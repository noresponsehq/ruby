# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # IntegrationPlatform - The authentication provider that calls the endpoint.
      class IntegrationPlatform
        include ::Crystalline::Enum
        enums do
          WORKOS = new("workos")
          AUTH0 = new("auth0")
        end

        open!
      end
    end
  end
end
