# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class OtherGroupMatchedOn
        include ::Crystalline::Enum
        enums do
          PERSON_ID = new("person_id")
        end

        open!
      end
    end
  end
end
