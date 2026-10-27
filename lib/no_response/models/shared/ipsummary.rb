# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Facts about the submitted IP from the offline database and this workspace's own recent assessments. Every member is optional; absent makes no claim.
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
        # Autonomous system number of the network that announces the address, from the offline database. Absent when unknown.
        field(
          :asn,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("asn")}}
        )
        # Assessments in this workspace with the same IP in the last 24 hours, this one included. A count only.
        field(
          :seen_in_workspace,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("seen_in_workspace")}}
        )

        sig {
          params(
            country: T.nilable(::String),
            type: T.nilable(Models::Shared::IpSummaryType),
            asn: T.nilable(::Integer),
            seen_in_workspace: T.nilable(::Integer)
          )
            .void
        }
        def initialize(country: nil, type: nil, asn: nil, seen_in_workspace: nil)
          @country = country
          @type = type
          @asn = asn
          @seen_in_workspace = seen_in_workspace
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @country == other.country
          return false unless @type == other.type
          return false unless @asn == other.asn
          return false unless @seen_in_workspace == other.seen_in_workspace
          true
        end
      end
    end
  end
end
