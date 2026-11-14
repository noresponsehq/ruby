# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One identifier that ties a profile to the person.
      class ScreeningMatchEvidence
        extend T::Sig
        include Crystalline::MetadataFields

        # What matched. email, phone, supplied_handle and source_fact are hard identifiers; company, city and school are soft. supplied_handle is a handle on the person row; source_fact is an account a profile found by the person's lookups lists.
        field(
          :kind,
          Models::Shared::ScreeningMatchEvidenceKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ScreeningMatchEvidenceKind, false)
            }
          }
        )
        # The resolver, collector or analyser that produced a record, by its catalogue name.
        field(
          :resolver,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("resolver"), required: true}}
        )
        # Where the match was seen, such as the profile field that carried it.
        field(
          :detail,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("detail")}}
        )

        sig {
          params(kind: Models::Shared::ScreeningMatchEvidenceKind, resolver: ::String, detail: T.nilable(::String)).void
        }
        def initialize(kind:, resolver:, detail: nil)
          @kind = kind
          @resolver = resolver
          @detail = detail
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @kind == other.kind
          return false unless @resolver == other.resolver
          return false unless @detail == other.detail
          true
        end
      end
    end
  end
end
