# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # IdentifierKind - Which submitted identifier a signal concerns. ip is a selector of breach_exposure only.
      class IdentifierKind
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          USERNAME = new("username")
          PHONE = new("phone")
          IP = new("ip")
        end

        open!
      end
    end
  end
end
