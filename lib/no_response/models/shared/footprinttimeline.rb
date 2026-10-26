# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One identifier's dated footprint across every source: the first and last year any event was seen, the years between them, the latest year a source dated activity (omitted when none did), how many distinct sites and which kinds of evidence saw it.
      class FootprintTimeline
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :first_seen_year,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("first_seen_year"), required: true}}
        )

        field(
          :last_seen_year,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("last_seen_year"), required: true}}
        )

        field(
          :span_years,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("span_years"), required: true}}
        )

        field(
          :sites,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sites"), required: true}}
        )

        field(
          :families,
          Crystalline::Array.new(Models::Shared::FootprintFamily),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("families"), required: true}}
        )

        field(
          :last_active_year,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("last_active_year")}}
        )

        sig {
          params(
            first_seen_year: ::Integer,
            last_seen_year: ::Integer,
            span_years: ::Integer,
            sites: ::Integer,
            families: T::Array[Models::Shared::FootprintFamily],
            last_active_year: T.nilable(::Integer)
          )
            .void
        }
        def initialize(first_seen_year:, last_seen_year:, span_years:, sites:, families:, last_active_year: nil)
          @first_seen_year = first_seen_year
          @last_seen_year = last_seen_year
          @span_years = span_years
          @sites = sites
          @families = families
          @last_active_year = last_active_year
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @first_seen_year == other.first_seen_year
          return false unless @last_seen_year == other.last_seen_year
          return false unless @span_years == other.span_years
          return false unless @sites == other.sites
          return false unless @families == other.families
          return false unless @last_active_year == other.last_active_year
          true
        end
      end
    end
  end
end
