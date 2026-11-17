# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # How distinctive a searchable value is: an email, phone, username, password, hash, person name or IP. Absent for other values, for a field with no value, and when its rating could not be worked out, such as when a count failed. Linkage weighs a password, hash or username by these numbers: the rarer the value, the more a shared one counts.
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
        # How many breach rows hold the value, when they were counted. Set for a username, password, hash or person name.
        field(
          :rows,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("rows")}}
        )
        # How many times the Pwned Passwords list holds the password, when it was asked. Set for a password only.
        field(
          :pwned,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("pwned")}}
        )
        # How surprising the username is, to one decimal place: a character model spells it about once in 2^bits usernames. Set for a username the model can spell.
        field(
          :bits,
          Crystalline::Nilable.new(::Float),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("bits")}}
        )

        sig {
          params(
            rating: Models::Shared::Rating,
            reason: ::String,
            rows: T.nilable(::Integer),
            pwned: T.nilable(::Integer),
            bits: T.nilable(::Float)
          )
            .void
        }
        def initialize(rating:, reason:, rows: nil, pwned: nil, bits: nil)
          @rating = rating
          @reason = reason
          @rows = rows
          @pwned = pwned
          @bits = bits
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @rating == other.rating
          return false unless @reason == other.reason
          return false unless @rows == other.rows
          return false unless @pwned == other.pwned
          return false unless @bits == other.bits
          true
        end
      end
    end
  end
end
