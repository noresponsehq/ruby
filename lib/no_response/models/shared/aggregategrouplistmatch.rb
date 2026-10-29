# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AggregateGroupListMatch - The list action captured with the first answer. none means no matching entry was found. For retained_first_answers an absent field means the older assessment did not capture list state; this remains a separate group.
      class AggregateGroupListMatch
        include ::Crystalline::Enum
        enums do
          BLOCK = new("block")
          ALLOW = new("allow")
          NONE = new("none")
        end

        open!
      end
    end
  end
end
