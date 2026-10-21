# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ConflictErrorCode - Machine codes an HTTP 409 answer can carry.
      class ConflictErrorCode
        include ::Crystalline::Enum
        enums do
          IDEMPOTENCY_KEY_REUSED = new("idempotency_key_reused")
          KEY_ROTATION_IN_PROGRESS = new("key_rotation_in_progress")
        end

        open!
      end
    end
  end
end
