# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PersonMatchMatchedOn
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          PHONE = new("phone")
        end

        open!
      end
    end
  end
end
