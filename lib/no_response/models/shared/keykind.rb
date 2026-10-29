# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class KeyKind
        include ::Crystalline::Enum
        enums do
          SERVICE = new("service")
          PERSONAL = new("personal")
        end

        open!
      end
    end
  end
end
