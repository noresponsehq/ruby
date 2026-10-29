# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Conclusion
        include ::Crystalline::Enum
        enums do
          BENIGN = new("benign")
          ABUSE = new("abuse")
          INCONCLUSIVE = new("inconclusive")
        end

        open!
      end
    end
  end
end
