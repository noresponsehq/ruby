# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ErasureReceiptKind
        include ::Crystalline::Enum
        enums do
          ASSESSMENT = new("assessment")
          ACCOUNT = new("account")
          WORKSPACE = new("workspace")
        end

        open!
      end
    end
  end
end
