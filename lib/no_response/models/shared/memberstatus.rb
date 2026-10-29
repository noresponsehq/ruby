# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # MemberStatus - Listed and returned members are active.
      class MemberStatus
        include ::Crystalline::Enum
        enums do
          ACTIVE = new("active")
        end

        open!
      end
    end
  end
end
