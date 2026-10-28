# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ListMatch - The action of the list entry that decided the account.
      class ListMatch
        include ::Crystalline::Enum
        enums do
          BLOCK = new("block")
          ALLOW = new("allow")
        end

        open!
      end
    end
  end
end
