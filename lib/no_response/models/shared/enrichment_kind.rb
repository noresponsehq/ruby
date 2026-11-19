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
          PERSON_NAME = new("person_name")
        end

        open!
      end
    end
  end
end
