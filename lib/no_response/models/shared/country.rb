# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Country - IP country, phone country, breach countries and policy_context.region together. When the breach records give a country, the timezone and locale countries count too. The IP country of a proxy or hosting network does not count.
      class Country
        include ::Crystalline::Enum
        enums do
          CONSISTENT = new("consistent")
          MISMATCH = new("mismatch")
          UNKNOWN = new("unknown")
        end

        open!
      end
    end
  end
end
