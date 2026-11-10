# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class MatchedOn
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          PHONE = new("phone")
          EXTERNAL_ID = new("external_id")
        end

        open!
      end
    end
  end
end
