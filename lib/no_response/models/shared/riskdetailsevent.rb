# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class RiskDetailsEvent
        extend T::Sig
        include Crystalline::MetadataFields

        field :year, ::Integer, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("year"), required: true}}

        field(
          :kind,
          Models::Shared::RiskDetailsEventKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::RiskDetailsEventKind, false)
            }
          }
        )

        field :site, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("site"), required: true}}

        field(
          :category,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("category"), required: true}}
        )
        # The source-neutral kind of evidence: account_presence (an account found on a site), auth_provider (the account at your auth provider), breach (breach and credential tables), breach_abuse (abuse and fraud communities' tables) and code_hosting (a code hosting profile).
        field(
          :family,
          Models::Shared::FootprintFamily,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("family"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::FootprintFamily, false)
            }
          }
        )

        field(
          :identifier,
          Models::Shared::Identifier,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("identifier"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Identifier, false)
            }
          }
        )

        field(
          :month,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("month")}}
        )

        sig {
          params(
            year: ::Integer,
            kind: Models::Shared::RiskDetailsEventKind,
            site: ::String,
            category: ::String,
            family: Models::Shared::FootprintFamily,
            identifier: Models::Shared::Identifier,
            month: T.nilable(::Integer)
          )
            .void
        }
        def initialize(year:, kind:, site:, category:, family:, identifier:, month: nil)
          @year = year
          @kind = kind
          @site = site
          @category = category
          @family = family
          @identifier = identifier
          @month = month
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @year == other.year
          return false unless @kind == other.kind
          return false unless @site == other.site
          return false unless @category == other.category
          return false unless @family == other.family
          return false unless @identifier == other.identifier
          return false unless @month == other.month
          true
        end
      end
    end
  end
end
