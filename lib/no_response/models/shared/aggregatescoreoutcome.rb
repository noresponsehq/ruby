# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # First answers of one flow whose risk.score is in [score_min, score_max] and whose assessment's latest reported outcome (the latest received) is outcome. Counted when the first answer is counted and moved when a later outcome wins; outcomes reported before the first answer was counted are counted with it. An outcome reported before this count existed is counted only once another outcome is reported for the assessment.
      class AggregateScoreOutcome
        extend T::Sig
        include Crystalline::MetadataFields

        # The event an assessment is made for: account_creation (a user creates an account), login (a user returns to an existing account) or purchase (a payment or a credit grant). The account's risk is reported with the decision for this flow.
        field(
          :flow,
          Models::Shared::Flow,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("flow"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Flow, false)
            }
          }
        )
        # A multiple of 5.
        field(
          :score_min,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_min"), required: true}}
        )

        field(
          :score_max,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_max"), required: true}}
        )
        # What the provider later learned about the assessed account. confirmed_abuse, account_takeover and chargeback report abuse; false_positive and legitimate withdraw an earlier abuse report of this workspace for the assessment; unknown is recorded only. Outcomes are append-only and the latest one recorded for an assessment wins.
        field(
          :outcome,
          Models::Shared::Outcome,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("outcome"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Outcome, false)
            }
          }
        )

        field(
          :count,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("count"), required: true}}
        )

        sig {
          params(
            flow: Models::Shared::Flow,
            score_min: ::Integer,
            score_max: ::Integer,
            outcome: Models::Shared::Outcome,
            count: ::Integer
          )
            .void
        }
        def initialize(flow:, score_min:, score_max:, outcome:, count:)
          @flow = flow
          @score_min = score_min
          @score_max = score_max
          @outcome = outcome
          @count = count
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @flow == other.flow
          return false unless @score_min == other.score_min
          return false unless @score_max == other.score_max
          return false unless @outcome == other.outcome
          return false unless @count == other.count
          true
        end
      end
    end
  end
end
