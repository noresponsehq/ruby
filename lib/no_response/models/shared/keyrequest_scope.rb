# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class KeyRequestScope < T::Enum
        enums do
          ASSESS = new("assess")
          HISTORY = new("history")
          DELETE = new("delete")
          WEBHOOKS = new("webhooks")
          DETAILED = new("detailed")
          INTEGRATIONS = new("integrations")
          MANAGEMENT = new("management")
        end
      end
    end
  end
end
