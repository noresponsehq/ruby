# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One searched value that found the record.
      class RecordMatch
        extend T::Sig
        include Crystalline::MetadataFields

        # The kind of searched value: email, phone, username, ip, name, or handle for a profile read of a handle.
        field :by, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("by"), required: true}}
        # The field the searched value hit, when the record holds it.
        field(
          :field,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("field")}}
        )

        sig { params(by: ::String, field: T.nilable(::String)).void }
        def initialize(by:, field: nil)
          @by = by
          @field = field
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @by == other.by
          return false unless @field == other.field
          true
        end
      end
    end
  end
end
