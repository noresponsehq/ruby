# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # RecordEvidenceSignal - found_by: what found the record, which sets where its likelihood starts. agrees: a value the record shares with what the investigator gave or with a joined record. clashes: a birth date, full name, gender or country that differs from theirs.
      class RecordEvidenceSignal
        include ::Crystalline::Enum
        enums do
          FOUND_BY = new("found_by")
          AGREES = new("agrees")
          CLASHES = new("clashes")
        end

        open!
      end
    end
  end
end
