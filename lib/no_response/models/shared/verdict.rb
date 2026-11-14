# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Verdict - A reviewer's overrule (POST .../people/{person_id}/records), which decides joined whatever the likelihood and sticks for as long as a lookup finds the same record. Absent when nobody overruled it.
      class Verdict
        include ::Crystalline::Enum
        enums do
          JOINED = new("joined")
          REJECTED = new("rejected")
        end

        open!
      end
    end
  end
end
