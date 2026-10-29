# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class MemberEnvironment
        include ::Crystalline::Enum
        enums do
          LIVE = new("live")
          TEST = new("test")
        end

        open!
      end
    end
  end
end
