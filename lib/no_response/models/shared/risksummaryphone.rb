# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class RiskSummaryPhone
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :line_type,
          Crystalline::Nilable.new(Models::Shared::LineType),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("line_type"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::LineType, true)
            }
          }
        )

        field(
          :country,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("country")}}
        )
        # Highest report count any source gave for the number.
        field(
          :report_count,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("report_count")}}
        )
        # Carrier-network metadata from privately weighted sources; not upstream provider attribution.
        field(
          :carrier,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("carrier")}}
        )

        sig {
          params(
            line_type: T.nilable(Models::Shared::LineType),
            country: T.nilable(::String),
            report_count: T.nilable(::Integer),
            carrier: T.nilable(::String)
          )
            .void
        }
        def initialize(line_type: nil, country: nil, report_count: nil, carrier: nil)
          @line_type = line_type
          @country = country
          @report_count = report_count
          @carrier = carrier
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @line_type == other.line_type
          return false unless @country == other.country
          return false unless @report_count == other.report_count
          return false unless @carrier == other.carrier
          true
        end
      end
    end
  end
end
