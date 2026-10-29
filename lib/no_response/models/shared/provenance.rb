# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Provenance - Customer-submitted input. It does not mean the customer or NoResponse verified ownership.
      class Provenance
        include ::Crystalline::Enum
        enums do
          SUBMITTED = new("submitted")
        end

        open!
      end
    end
  end
end
