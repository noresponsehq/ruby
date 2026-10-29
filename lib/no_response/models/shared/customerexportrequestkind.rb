# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class CustomerExportRequestKind
        include ::Crystalline::Enum
        enums do
          ACCOUNT = new("account")
          AUDIT = new("audit")
        end

        open!
      end
    end
  end
end
