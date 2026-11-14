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
        # The value as the source wrote it. A count is written in decimal and a time in RFC 3339.
        field(
          :original,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("original"), required: true}}
        )
        # What sort of value the field holds. Absent until the field's kind is known.
        field(
          :kind,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("kind")}}
        )
        # Which common field it is, where many sources share it, such as handle, display_name, account_id, profile_link, picture, bio, website, linked_account (named by its network), account_status, joined, last_updated, organisation, location, followers, following or posts. Absent for a field only this source returns.
        field(
          :role,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("role")}}
        )
        # The cleaned value. Absent when it cannot be cleaned, or until the field's kind is known.
        field(
          :value,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value")}}
        )

        sig {
          params(
            field: ::String,
            original: ::String,
            kind: T.nilable(::String),
            role: T.nilable(::String),
            value: T.nilable(::String)
          )
            .void
        }
        def initialize(field:, original:, kind: nil, role: nil, value: nil)
          @field = field
          @original = original
          @kind = kind
          @role = role
          @value = value
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @field == other.field
          return false unless @original == other.original
          return false unless @kind == other.kind
          return false unless @role == other.role
          return false unless @value == other.value
          true
        end
      end
    end
  end
end
