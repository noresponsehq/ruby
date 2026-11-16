# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Basis - stated: read from a record. inferred: reasoned from several facts. absence: every source answered and none found it.
      class Basis
        include ::Crystalline::Enum
        enums do
          STATED = new("stated")
          INFERRED = new("inferred")
          ABSENCE = new("absence")
        end

        open!
      end
    end
  end
end
