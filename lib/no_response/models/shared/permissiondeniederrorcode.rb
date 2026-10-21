# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # PermissionDeniedErrorCode - Machine codes an HTTP 403 answer can carry.
      class PermissionDeniedErrorCode
        include ::Crystalline::Enum
        enums do
          TENANT_FORBIDDEN = new("tenant_forbidden")
        end

        open!
      end
    end
  end
end
