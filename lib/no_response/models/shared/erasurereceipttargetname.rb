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
          CACHE = new("cache")
          DOWNSTREAM_PROJECTION = new("downstream_projection")
        end

        open!
      end
    end
  end
end
