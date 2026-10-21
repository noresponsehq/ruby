# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Facts about the submitted IP from the offline database and this tenant's own recent assessments. Every member is optional; absent makes no claim.
      class IpSummary
        extend T::Sig
        include Crystalline::MetadataFields

        # ISO 3166-1 alpha-2 country of the address.
        field(
          :country,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("country")}}
        )
        # The address's network type.
        field(
          :type,
          Crystalline::Nilable.new(Models::Shared::IpSummaryType),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("type"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::IpSummaryType, true)
            }
          }
        )
        # Assessments in this tenant with the same IP in the last 24 hours, this one included. A count only.
        field(
          :seen_in_tenant,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("seen_in_tenant")}}
        )

        sig {
          params(
            country: T.nilable(::String),
            type: T.nilable(Models::Shared::IpSummaryType),
            seen_in_tenant: T.nilable(::Integer)
          )
            .void
        }
        def initialize(country: nil, type: nil, seen_in_tenant: nil)
          @country = country
          @type = type
          @seen_in_tenant = seen_in_tenant
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @country == other.country
          return false unless @type == other.type
          return false unless @seen_in_tenant == other.seen_in_tenant
          true
        end
      end
    end
  end
end
