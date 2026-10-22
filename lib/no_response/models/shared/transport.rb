# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Transport - Where this context was derived. Backend is the trusted integration path; browser values are treated as weak hints. provider_hook is a hosted provider hook (an Auth0 or WorkOS Action) calling at hook_point; it needs hook_point and verified false, and its authentication facts are not scored.
      class Transport < T::Enum
        enums do
          BACKEND = new("backend")
          BROWSER = new("browser")
          PROVIDER_HOOK = new("provider_hook")
        end
      end
    end
  end
end
