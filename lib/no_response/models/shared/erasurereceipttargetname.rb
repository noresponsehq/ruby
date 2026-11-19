# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ErasureReceiptTargetName
        include ::Crystalline::Enum
        enums do
          SERVING = new("serving")
          OUTBOX = new("outbox")
        end

        open!
      end
    end
  end
end
