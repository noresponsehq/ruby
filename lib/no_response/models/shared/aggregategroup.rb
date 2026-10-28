# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One group's count in one bucket. It holds each grouped dimension the counted assessments had a value for: a pending first answer has no decision, recommendation or band; an answer that fired no reason, listed no incomplete lane, matched no list entry or whose IP has no known country or ASN leaves that dimension out.
      class AggregateGroup
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :count,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("count"), required: true}}
        )
        # An assessment's own decision: block when its stored risk.block is true, otherwise its recommendation. It is not the account's decision or held-admission state.
        field(
          :decision,
          Crystalline::Nilable.new(Models::Shared::Decision),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Decision, true)
            }
          }
        )
        # The event an assessment is made for: account_creation (a user creates an account), login (a user returns to an existing account) or purchase (a payment or a credit grant). The account's risk is reported with the decision for this flow.
        field(
          :flow,
          Crystalline::Nilable.new(Models::Shared::Flow),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("flow"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Flow, true)
            }
          }
        )
        # The recommended action: allow, step_up or review. Your application applies it.
        field(
          :recommendation,
          Crystalline::Nilable.new(Models::Shared::Recommendation),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("recommendation"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Recommendation, true)
            }
          }
        )
        # low 0-29, medium 30-59, high 60-84, critical 85-100.
        field(
          :band,
          Crystalline::Nilable.new(Models::Shared::Band),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("band"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Band, true)
            }
          }
        )
        # The action of the list entry that decided the account.
        field(
          :list_match,
          Crystalline::Nilable.new(Models::Shared::ListMatch),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("list_match"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ListMatch, true)
            }
          }
        )
        # A stable reason code. New codes may appear; ignore any you do not know.
        field(
          :reason,
          Crystalline::Nilable.new(Models::Shared::ReasonCode),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("reason"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ReasonCode, true)
            }
          }
        )

        field(
          :impact,
          Crystalline::Nilable.new(Models::Shared::Impact),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("impact"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Impact, true)
            }
          }
        )
        # An evidence lane: accounts (account presence for email and username), phone, breach, domain (the email domain's registration) and ip.
        field(
          :lane,
          Crystalline::Nilable.new(Models::Shared::Lane),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("lane"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Lane, true)
            }
          }
        )

        field(
          :country,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("country")}}
        )

        field(
          :asn,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("asn")}}
        )

        sig {
          params(
            count: ::Integer,
            decision: T.nilable(Models::Shared::Decision),
            flow: T.nilable(Models::Shared::Flow),
            recommendation: T.nilable(Models::Shared::Recommendation),
            band: T.nilable(Models::Shared::Band),
            list_match: T.nilable(Models::Shared::ListMatch),
            reason: T.nilable(Models::Shared::ReasonCode),
            impact: T.nilable(Models::Shared::Impact),
            lane: T.nilable(Models::Shared::Lane),
            country: T.nilable(::String),
            asn: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          count:,
          decision: nil,
          flow: nil,
          recommendation: nil,
          band: nil,
          list_match: nil,
          reason: nil,
          impact: nil,
          lane: nil,
          country: nil,
          asn: nil
        )
          @count = count
          @decision = decision
          @flow = flow
          @recommendation = recommendation
          @band = band
          @list_match = list_match
          @reason = reason
          @impact = impact
          @lane = lane
          @country = country
          @asn = asn
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @count == other.count
          return false unless @decision == other.decision
          return false unless @flow == other.flow
          return false unless @recommendation == other.recommendation
          return false unless @band == other.band
          return false unless @list_match == other.list_match
          return false unless @reason == other.reason
          return false unless @impact == other.impact
          return false unless @lane == other.lane
          return false unless @country == other.country
          return false unless @asn == other.asn
          true
        end
      end
    end
  end
end
