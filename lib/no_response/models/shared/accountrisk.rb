# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AccountRisk
        extend T::Sig
        include Crystalline::MetadataFields

        # 0 (safe) to 100 (risky), as risk.score of the assessment.
        field(
          :score,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score"), required: true}}
        )
        # block when the score reached your block threshold (risk.block of the assessment), otherwise the assessment's recommendation. Your application applies it.
        field(
          :decision,
          Models::Shared::AccountDecision,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AccountDecision, false)
            }
          }
        )
        # Every reason that fired, highest weight first. The weights sum to score before clamping.
        field(
          :reasons,
          Crystalline::Array.new(Models::Shared::AccountRiskReason),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reasons"), required: true}}
        )

        sig {
          params(
            score: ::Integer,
            decision: Models::Shared::AccountDecision,
            reasons: T::Array[Models::Shared::AccountRiskReason]
          )
            .void
        }
        def initialize(score:, decision:, reasons:)
          @score = score
          @decision = decision
          @reasons = reasons
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @score == other.score
          return false unless @decision == other.decision
          return false unless @reasons == other.reasons
          true
        end
      end
    end
  end
end
