# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # KeyStatus - active: the key authenticates. expired: a rotation's overlap window has ended (expires_at). revoked: the key was revoked (revoked_at) and answers 401.
      class KeyStatus
        include ::Crystalline::Enum
        enums do
          ACTIVE = new("active")
          EXPIRED = new("expired")
          REVOKED = new("revoked")
        end

        open!
      end
    end
  end
end
