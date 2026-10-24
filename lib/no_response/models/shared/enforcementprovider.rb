# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # EnforcementProvider - The identity provider the action ran in; custom for the workspace's own user store.
      class EnforcementProvider
        include ::Crystalline::Enum
        enums do
          CLERK = new("clerk")
          WORKOS = new("workos")
          AUTH0 = new("auth0")
          CUSTOM = new("custom")
        end

        open!
      end
    end
  end
end
