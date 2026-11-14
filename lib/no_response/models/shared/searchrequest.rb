# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The value to search again, named by the record and field that hold it rather than sent again.
      class SearchRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # One of the person's records: a lookup's, a profile's or one an earlier search found.
        field(
          :record_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("record_id"), required: true}}
        )
        # The name of the record's field whose value to search. Its kind must be email, phone, username, person_name, password, hash or ip.
        field(
          :field,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("field"), required: true}}
        )
        # Search only this breach table, as a remaining entry names it, to fetch the rows an earlier search left out. Not for a phone.
        field(
          :table,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("table")}}
        )

        sig { params(record_id: ::String, field: ::String, table: T.nilable(::String)).void }
        def initialize(record_id:, field:, table: nil)
          @record_id = record_id
          @field = field
          @table = table
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @record_id == other.record_id
          return false unless @field == other.field
          return false unless @table == other.table
          true
        end
      end
    end
  end
end
