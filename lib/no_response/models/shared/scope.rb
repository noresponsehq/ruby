# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Scope
        include ::Crystalline::Enum
        enums do
          ASSESS = new("assess")
          HISTORY = new("history")
          WEBHOOKS = new("webhooks")
          DETAILED = new("detailed")
          INTEGRATIONS = new("integrations")
        end

        open!
      end
    end
  end
end
