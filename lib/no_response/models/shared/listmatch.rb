# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ListMatch - The list action captured at the first answer. Requires revision first. Older answers without captured list state do not match, including none.
      class ListMatch < T::Enum
        enums do
          ALLOW = new("allow")
          BLOCK = new("block")
          NONE = new("none")
        end
      end
    end
  end
end
