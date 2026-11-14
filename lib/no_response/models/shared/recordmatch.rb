# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One searched value that found the record.
      class RecordMatch
        extend T::Sig
        include Crystalline::MetadataFields

        # The kind of searched value: email, phone, username, ip, name, password, hash, or handle for a profile read of a handle.
        field :by, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("by"), required: true}}
        # The field the searched value hit, when the record holds it.
        field(
          :field,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("field")}}
        )
        # The search a person started on a value of another record that found this one, among the person report's searches, which names the value and the record and field it came from. A record found only by such searches is a lead, whatever kind of value found it. Absent for a match of the lookups.
        field(
          :search,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("search")}}
        )

        sig { params(by: ::String, field: T.nilable(::String), search: T.nilable(::String)).void }
        def initialize(by:, field: nil, search: nil)
          @by = by
          @field = field
          @search = search
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @by == other.by
          return false unless @field == other.field
          return false unless @search == other.search
          true
        end
      end
    end
  end
end
