# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # DefaultDepth - The depth a request for this flow that names none is served at. Defaults: full for account_creation and purchase, quick for login.
      class DefaultDepth
        include ::Crystalline::Enum
        enums do
          QUICK = new("quick")
          FULL = new("full")
        end

        open!
      end
    end
  end
end
