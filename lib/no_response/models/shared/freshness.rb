# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Freshness - Freshness class of the evidence behind a signal. unknown whenever no evidence was obtained.
      class Freshness
        include ::Crystalline::Enum
        enums do
          FRESH = new("fresh")
          STALE = new("stale")
          UNKNOWN = new("unknown")
        end

        open!
      end
    end
  end
end
