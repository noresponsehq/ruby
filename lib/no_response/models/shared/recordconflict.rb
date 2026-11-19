# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Two identifiers you gave that lead to records of different people.
      class RecordConflict
        extend T::Sig
        include Crystalline::MetadataFields

        # anchors_disagree: records found by two of the identifiers you gave clash with each other, so those identifiers may belong to different people.
        field(
          :signal,
          Models::Shared::RecordConflictSignal,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("signal"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::RecordConflictSignal, false)
            }
          }
        )
        # The kind of value that clashes: person_name or born.
        field :kind, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("kind"), required: true}}
        # The two identifiers you gave whose records disagree.
        field(
          :between,
          Crystalline::Array.new(Models::Shared::Between),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("between"), required: true}}
        )
        # The ids of the two records that clash, in the order of between.
        field(
          :records,
          Crystalline::Array.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("records"), required: true}}
        )

        sig {
          params(
            signal: Models::Shared::RecordConflictSignal,
            kind: ::String,
            between: T::Array[Models::Shared::Between],
            records: T::Array[::String]
          )
            .void
        }
        def initialize(signal:, kind:, between:, records:)
          @signal = signal
          @kind = kind
          @between = between
          @records = records
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @signal == other.signal
          return false unless @kind == other.kind
          return false unless @between == other.between
          return false unless @records == other.records
          true
        end
      end
    end
  end
end
