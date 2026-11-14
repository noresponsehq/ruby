# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One answer from one source: where it came from, what found it and every field it holds.
      class Record
        extend T::Sig
        include Crystalline::MetadataFields

        # Made from the source and the fields' names and original values, so the same answer found twice is one record with the same id.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # Where a record came from.
        field(
          :source,
          Models::Shared::RecordSource,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("source"), required: true}}
        )
        # Each kind of searched value that found the record.
        field(
          :matched,
          Crystalline::Array.new(Models::Shared::RecordMatch),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("matched"), required: true}}
        )
        # Every field the source returned, in the order the source's connector lists them; a breach row's columns in name order. Nothing is withheld: a breach row's passwords, hashes and salts are fields like any other.
        field(
          :fields_,
          Crystalline::Array.new(Models::Shared::RecordField),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("fields"), required: true}}
        )
        # When the source last gave this answer.
        field(
          :observed_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("observed_at"), required: true}}
        )

        sig {
          params(
            id: ::String,
            source: Models::Shared::RecordSource,
            matched: T::Array[Models::Shared::RecordMatch],
            fields_: T::Array[Models::Shared::RecordField],
            observed_at: ::String
          )
            .void
        }
        def initialize(id:, source:, matched:, fields_:, observed_at:)
          @id = id
          @source = source
          @matched = matched
          @fields_ = fields_
          @observed_at = observed_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @source == other.source
          return false unless @matched == other.matched
          return false unless @fields_ == other.fields_
          return false unless @observed_at == other.observed_at
          true
        end
      end
    end
  end
end
