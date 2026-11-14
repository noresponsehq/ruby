# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Rows one search matched in one source that the lookup's records leave out, so no answer is cut short in silence.
      class RecordRemaining
        extend T::Sig
        include Crystalline::MetadataFields

        # Where a record came from.
        field(
          :source,
          Models::Shared::RecordSource,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("source"), required: true}}
        )
        # The kind of searched value whose search matched the rows, as a record's matched names it.
        field :by, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("by"), required: true}}
        # How many rows of the source that search matched beyond the records the lookup carries.
        field :rows, ::Integer, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("rows"), required: true}}
        # The search a person started that matched the rows. Searching the same field again with this source's table fetches them.
        field(
          :search,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("search")}}
        )

        sig {
          params(source: Models::Shared::RecordSource, by: ::String, rows: ::Integer, search: T.nilable(::String)).void
        }
        def initialize(source:, by:, rows:, search: nil)
          @source = source
          @by = by
          @rows = rows
          @search = search
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @source == other.source
          return false unless @by == other.by
          return false unless @rows == other.rows
          return false unless @search == other.search
          true
        end
      end
    end
  end
end
