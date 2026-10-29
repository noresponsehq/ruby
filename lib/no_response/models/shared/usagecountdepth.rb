# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # UsageCountDepth - assessments only.
      class UsageCountDepth
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
