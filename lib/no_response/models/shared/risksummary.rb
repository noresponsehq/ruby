# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A few typed facts per identifier. Every fact is optional: absent means the evidence did not answer and makes no claim, while false or 0 is a definite answer. Lanes that do not exist yet leave their members absent.
      class RiskSummary
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :phone,
          Crystalline::Nilable.new(Models::Shared::RiskSummaryPhone),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone")}}
        )

        field(
          :email,
          Crystalline::Nilable.new(Models::Shared::RiskSummaryEmail),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )

        field(
          :username,
          Crystalline::Nilable.new(Models::Shared::RiskSummaryUsername),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("username")}}
        )
        # Facts about the submitted IP from the offline database and this tenant's own recent assessments. Every member is optional; absent makes no claim.
        field(
          :ip,
          Crystalline::Nilable.new(Models::Shared::IpSummary),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("ip")}}
        )
        # Cross-identifier agreement, computed from facts only. Every member is optional; absent makes no claim.
        field(
          :consistency,
          Crystalline::Nilable.new(Models::Shared::Consistency),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("consistency")}}
        )

        sig {
          params(
            phone: T.nilable(Models::Shared::RiskSummaryPhone),
            email: T.nilable(Models::Shared::RiskSummaryEmail),
            username: T.nilable(Models::Shared::RiskSummaryUsername),
            ip: T.nilable(Models::Shared::IpSummary),
            consistency: T.nilable(Models::Shared::Consistency)
          )
            .void
        }
        def initialize(phone: nil, email: nil, username: nil, ip: nil, consistency: nil)
          @phone = phone
          @email = email
          @username = username
          @ip = ip
          @consistency = consistency
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @phone == other.phone
          return false unless @email == other.email
          return false unless @username == other.username
          return false unless @ip == other.ip
          return false unless @consistency == other.consistency
          true
        end
      end
    end
  end
end
