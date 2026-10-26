# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class RiskDetailsEventKind
        include ::Crystalline::Enum
        enums do
          CREATED = new("created")
          LAST_ACTIVE = new("last_active")
          BREACHED = new("breached")
        end

        open!
      end
    end
  end
end
