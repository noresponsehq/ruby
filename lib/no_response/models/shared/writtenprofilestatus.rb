# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # WrittenProfileStatus - queued: the profile is being written. written: summary, statements and leads hold it. failed: it could not be written; error_code says why and no content is returned.
      class WrittenProfileStatus
        include ::Crystalline::Enum
        enums do
          QUEUED = new("queued")
          WRITTEN = new("written")
          FAILED = new("failed")
        end

        open!
      end
    end
  end
end
