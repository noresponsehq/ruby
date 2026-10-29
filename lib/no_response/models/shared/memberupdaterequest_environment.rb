# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class MemberUpdateRequestEnvironment < T::Enum
        enums do
          LIVE = new("live")
          TEST = new("test")
        end
      end
    end
  end
end
