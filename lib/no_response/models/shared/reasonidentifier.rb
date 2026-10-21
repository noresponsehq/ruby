# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ReasonIdentifier - The submitted identifier or client context field a reason concerns; absent when it concerns the whole assessment. Client context is a claimed hint, not a device fingerprint.
      class ReasonIdentifier
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          USERNAME = new("username")
          PHONE = new("phone")
          NAME = new("name")
          IP = new("ip")
          CONTEXT = new("context")
        end

        open!
      end
    end
  end
end
