# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ListImpactKind
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          EMAIL_DOMAIN = new("email_domain")
        end

        open!
      end
    end
  end
end
