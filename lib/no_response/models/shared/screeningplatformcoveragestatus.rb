# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ScreeningPlatformCoverageStatus - covered read at least one profile; none_found looked and found no account; inaccessible found accounts that are private or locked; failed could not finish looking; unavailable has no resolver or collector enabled.
      class ScreeningPlatformCoverageStatus
        include ::Crystalline::Enum
        enums do
          COVERED = new("covered")
          NONE_FOUND = new("none_found")
          INACCESSIBLE = new("inaccessible")
          FAILED = new("failed")
          UNAVAILABLE = new("unavailable")
        end

        open!
      end
    end
  end
end
