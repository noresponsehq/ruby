# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One value a source returned.
      class RecordField
        extend T::Sig
        include Crystalline::MetadataFields

        # The source's own name for the field. A nested value's name is dotted, and a list element's carries its index.
        field(
          :field,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("field"), required: true}}
        )
        # The value as the source wrote it. A count is written in decimal and a time in RFC 3339; a breach column's value is as the leak holds it.
        field(
          :original,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("original"), required: true}}
        )
        # What sort of value a field holds, which decides how it is cleaned, compared and searched again. It comes from the value itself where its shape is certain (an email, an IP, a URL, an international phone number), else from the answer stored for the source's column, else text. A value of any kind is returned. Each kind's description says what it holds and the form value takes.
        field(
          :kind,
          Crystalline::Nilable.new(Models::Shared::RecordKind),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::RecordKind, true)
            }
          }
        )
        # Which common field a value is, where many sources share it: a join date and a birth date are both dates, with the roles joined and born. A platform account's field and a breach row's column with the same meaning carry the same kind and role. A linked_account field is named by its network. Absent for a field only its source returns. Each role's description names the kinds its values have.
        field(
          :role,
          Crystalline::Nilable.new(Models::Shared::RecordRole),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("role"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::RecordRole, true)
            }
          }
        )
        # The value cleaned to its kind's one form: an email in lower case, a phone number in international form when its country is known, a date in ISO form, a country as its two-letter code, a flag as true or false. Absent when the value cannot be cleaned as its kind; original still holds it.
        field(
          :value,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value")}}
        )
        # What the value shows of itself beyond its kind: the likely algorithm of a hash, the likely coin of a crypto address or the currency of an amount.
        field(
          :detail,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("detail")}}
        )
        # How distinctive a searchable value is: an email, phone, username, password, hash, person name or IP. Absent for other values, and when its rating could not be worked out, such as when a count failed.
        field(
          :distinctive,
          Crystalline::Nilable.new(Models::Shared::RecordDistinctive),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("distinctive")}}
        )

        sig {
          params(
            field: ::String,
            original: ::String,
            kind: T.nilable(Models::Shared::RecordKind),
            role: T.nilable(Models::Shared::RecordRole),
            value: T.nilable(::String),
            detail: T.nilable(::String),
            distinctive: T.nilable(Models::Shared::RecordDistinctive)
          )
            .void
        }
        def initialize(field:, original:, kind: nil, role: nil, value: nil, detail: nil, distinctive: nil)
          @field = field
          @original = original
          @kind = kind
          @role = role
          @value = value
          @detail = detail
          @distinctive = distinctive
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @field == other.field
          return false unless @original == other.original
          return false unless @kind == other.kind
          return false unless @role == other.role
          return false unless @value == other.value
          return false unless @detail == other.detail
          return false unless @distinctive == other.distinctive
          true
        end
      end
    end
  end
end
