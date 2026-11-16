# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ProfileCitation
        extend T::Sig
        include Crystalline::MetadataFields

        # record: a record in lookup.records or profiles[].record. post: an item in posts. check: an item in lookup.checks.
        field(
          :kind,
          Models::Shared::ProfileCitationKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ProfileCitationKind, false)
            }
          }
        )
        # The record or post id. For a check, c followed by its 1-based position in lookup.checks.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        sig { params(kind: Models::Shared::ProfileCitationKind, id: ::String).void }
        def initialize(kind:, id:)
          @kind = kind
          @id = id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @kind == other.kind
          return false unless @id == other.id
          true
        end
      end
    end
  end
end
