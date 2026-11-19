# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ScreeningSpendLineRole - What the implementation did. analyser appears only on spend recorded before the engine stopped analysing posts.
      class ScreeningSpendLineRole
        include ::Crystalline::Enum
        enums do
          RESOLVER = new("resolver")
          COLLECTOR = new("collector")
          ANALYSER = new("analyser")
        end

        open!
      end
    end
  end
end
