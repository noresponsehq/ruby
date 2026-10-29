# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class CustomerExportRequestFilterOutcome
        include ::Crystalline::Enum
        enums do
          SUCCEEDED = new("succeeded")
          DENIED = new("denied")
        end

        open!
      end
    end
  end
end
