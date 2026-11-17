# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # SuggestedSearchKind - The kind of the value: one of the kinds the environment's enrichment setting names.
      class SuggestedSearchKind
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
