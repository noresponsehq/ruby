# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class LastError
        include ::Crystalline::Enum
        enums do
          SCREENING_CAP_EXCEEDED = new("screening_cap_exceeded")
          SCREENING_UNAVAILABLE = new("screening_unavailable")
          PERSON_NOT_FOUND = new("person_not_found")
          IDEMPOTENCY_KEY_REUSED = new("idempotency_key_reused")
        end

        open!
      end
    end
  end
end
