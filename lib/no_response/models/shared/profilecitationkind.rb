# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ProfileCitationKind - record: a record in lookup.records or profiles[].record. post: an item in posts. check: an item in lookup.checks.
      class ProfileCitationKind
        include ::Crystalline::Enum
        enums do
          RECORD = new("record")
          POST = new("post")
          CHECK = new("check")
        end

        open!
      end
    end
  end
end
