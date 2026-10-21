# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # NotFoundErrorCode - Machine codes an HTTP 404 answer can carry.
      class NotFoundErrorCode
        include ::Crystalline::Enum
        enums do
          NOT_FOUND = new("not_found")
        end

        open!
      end
    end
  end
end
