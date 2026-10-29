# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ErasureReceiptTargetStatus
        include ::Crystalline::Enum
        enums do
          PENDING = new("pending")
          COMPLETED = new("completed")
        end

        open!
      end
    end
  end
end
