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

        sig { params(source: Models::Shared::RecordSource, by: ::String, rows: ::Integer).void }
        def initialize(source:, by:, rows:)
          @source = source
          @by = by
          @rows = rows
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @source == other.source
          return false unless @by == other.by
          return false unless @rows == other.rows
          true
        end
      end
    end
  end
end
