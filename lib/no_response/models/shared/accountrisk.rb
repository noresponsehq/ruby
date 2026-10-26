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
        # block when the score reached your block threshold (risk.block of the assessment), otherwise the assessment's recommendation. held only for a flow whose admission is held (settings flows.<flow>.admission), when the account's current assessment was made for that flow and its investigation has not completed (status partial): the final decision arrives as account.risk_changed when the investigation completes, decided by its score, or when the hold's deadline (hold_seconds after the assessment was created) passes first, as the flow's on_expiry action or the decision the evidence so far gives, whichever is stricter. Your application applies it.
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
        # Every reason that fired: risk-raising reasons first, then neutral, then risk-lowering, each strongest impact band first and then by code. The policy's numeric weights are kept private, so a reason carries only its direction and impact band.
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
