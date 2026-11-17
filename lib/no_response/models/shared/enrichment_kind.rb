# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class EnrichmentKind
        include ::Crystalline::Enum
        enums do
          USERNAME = new("username")
          EMAIL = new("email")
          PHONE = new("phone")
        end

        open!
      end
    end
  end
end
