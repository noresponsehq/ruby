# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # How distinctive a searchable value is: an email, phone, username, password, hash, person name or IP. Absent for other values, and when its rating could not be worked out, such as when a count failed.
      class RecordDistinctive
        extend T::Sig
        include Crystalline::MetadataFields

        # unique: an email or phone, which belongs to one person by design. distinctive: rare enough that a new search on it likely finds one person. common: shared by many people, so a search on it finds strangers. A new search is suggested for unique and distinctive values only; any value can still be searched.
        field(
          :rating,
          Models::Shared::Rating,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("rating"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Rating, false)
            }
          }
        )
        # Why, in plain words, such as "seen 3,861,493 times in breach data", "in 4 breach rows" or "38 bits, about one in 430 billion usernames".
        field(
          :reason,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reason"), required: true}}
        )

        sig { params(rating: Models::Shared::Rating, reason: ::String).void }
        def initialize(rating:, reason:)
          @rating = rating
          @reason = reason
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @rating == other.rating
          return false unless @reason == other.reason
          true
        end
      end
    end
  end
end
