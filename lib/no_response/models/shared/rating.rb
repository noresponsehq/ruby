# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Rating - unique: an email or phone, which belongs to one person by design. distinctive: rare enough that a new search on it likely finds one person. common: shared by many people, so a search on it finds strangers. A new search is suggested for unique and distinctive values only; any value can still be searched.
      class Rating
        include ::Crystalline::Enum
        enums do
          UNIQUE = new("unique")
          DISTINCTIVE = new("distinctive")
          COMMON = new("common")
        end

        open!
      end
    end
  end
end
