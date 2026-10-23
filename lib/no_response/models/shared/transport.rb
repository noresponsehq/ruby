# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Transport - Where the context was derived: backend (also when the request named no transport), browser, or provider_hook for a hosted provider hook.
      class Transport
        include ::Crystalline::Enum
        enums do
          BACKEND = new("backend")
          BROWSER = new("browser")
          PROVIDER_HOOK = new("provider_hook")
        end

        open!
      end
    end
  end
end
