# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ScreeningLookupCheckStatus - found: a source found the identifier. not_found: every source answered and none found it. partial: the sources that answered found nothing and the others did not answer. not_covered: no source answered. A lookup that failed reads partial or not_covered, not not_found.
      class ScreeningLookupCheckStatus
        include ::Crystalline::Enum
        enums do
          FOUND = new("found")
          NOT_FOUND = new("not_found")
          PARTIAL = new("partial")
          NOT_COVERED = new("not_covered")
        end

        open!
      end
    end
  end
end
