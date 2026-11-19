# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One item of evidence behind a record's likelihood.
      class RecordEvidence
        extend T::Sig
        include Crystalline::MetadataFields

        # found_by: what found the record, which sets where its likelihood starts. agrees: a value the record shares with what the investigator gave or with a joined record. clashes: a birth date, full name, gender or country that differs from theirs.
        field(
          :signal,
          Models::Shared::RecordEvidenceSignal,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("signal"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::RecordEvidenceSignal, false)
            }
          }
        )
        # The item's weight in bits, to two places: log2 of how much likelier the evidence is for the same person than for a stranger. Positive raises the likelihood and negative lowers it.
        field :bits, ::Float, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("bits"), required: true}}
        # For found_by, what the search looked up (email, phone, username, handle, name). Otherwise the kind of value compared, such as email, username, person_name, born, city or crypto_address.
        field(
          :kind,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("kind")}}
        )
        # The record's own field that agreed or clashed, or for found_by the field the search matched.
        field(
          :field,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("field")}}
        )
        # given for what the investigator gave, or the id of the person's record it agreed or clashed with, or for found_by the record whose value the search looked up.
        field(
          :with,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("with")}}
        )
        # The field on the other side: the field of the given identity or of the record named by with.
        field(
          :with_field,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("with_field")}}
        )

        sig {
          params(
            signal: Models::Shared::RecordEvidenceSignal,
            bits: ::Float,
            kind: T.nilable(::String),
            field: T.nilable(::String),
            with: T.nilable(::String),
            with_field: T.nilable(::String)
          )
            .void
        }
        def initialize(signal:, bits:, kind: nil, field: nil, with: nil, with_field: nil)
          @signal = signal
          @bits = bits
          @kind = kind
          @field = field
          @with = with
          @with_field = with_field
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @signal == other.signal
          return false unless @bits == other.bits
          return false unless @kind == other.kind
          return false unless @field == other.field
          return false unless @with == other.with
          return false unless @with_field == other.with_field
          true
        end
      end
    end
  end
end
