# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # RecordConflictSignal - anchors_disagree: records found by two of the identifiers you gave clash with each other, so those identifiers may belong to different people.
      class RecordConflictSignal
        include ::Crystalline::Enum
        enums do
          ANCHORS_DISAGREE = new("anchors_disagree")
        end

        open!
      end
    end
  end
end
