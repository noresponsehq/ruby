# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ListEntryAction - block decides block for the accounts the entry matches; allow decides allow. Block wins when both match.
      class ListEntryAction
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
