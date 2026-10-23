# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The one risk decision for this event. score is 0 (safe) to 100 (risky): the sum of the weights of the reasons that fired, clamped to 0 to 100, from hand-set versioned weights. Every answer with a recommendation carries it, and the top-level recommendation equals risk.recommendation. It names no source or provider.
      class Risk
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :score,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score"), required: true}}
        )
        # low 0-29, medium 30-59, high 60-84, critical 85-100.
        field(
          :band,
          Models::Shared::Band,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("band"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Band, false)
            }
          }
        )
        # The recommended action: allow, step_up or review. Your application applies it.
        field(
          :recommendation,
          Models::Shared::Recommendation,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("recommendation"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Recommendation, false)
            }
          }
        )
        # How much of the planned evidence answered; it says nothing about risk.
        field(
          :confidence,
          Models::Shared::RiskConfidence,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("confidence"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::RiskConfidence, false)
            }
          }
        )
        # Version of the hand-authored heuristic weights that produced the recommendation, for example 'risk-2026-10.7'. A workspace threshold override adds a +t<N> suffix, e.g. 'risk-2026-10.7+t3'.
        field(
          :policy_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("policy_version"), required: true}}
        )
        # Every reason that fired, highest weight first. The weights sum to score before clamping.
        field(
          :reasons,
          Crystalline::Array.new(Models::Shared::RiskReason),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reasons"), required: true}}
        )
        # Sources counted by state, not named.
        field(
          :coverage,
          Models::Shared::RiskCoverage,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("coverage"), required: true}}
        )
        # true when the workspace's block threshold is set and score reached it. A provider hook can deny the account creation on it; the provider decides and enforces. It does not change recommendation. It is false while blocking is off, the default, and a body from before the flag existed omits it: read absent as false.
        field(
          :block,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("block")}}
        )
        # The block threshold this answer used: block is true exactly when score is at least this value. Absent while blocking is off. NoResponse sets it per workspace on request, at or above the review threshold.
        field(
          :block_threshold,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("block_threshold")}}
        )
        # Labels the v0 policy as hand-authored and not statistically validated.
        field(
          :policy_basis,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("policy_basis"), required: true}}
        )
        # A few typed facts per identifier. Every fact is optional: absent means the evidence did not answer and makes no claim, while false or 0 is a definite answer. Lanes that do not exist yet leave their members absent.
        field(
          :summary,
          Crystalline::Nilable.new(Models::Shared::RiskSummary),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("summary")}}
        )
        # Detailed view only (response_mode=detailed, which needs the detailed scope); a standard answer leaves it out. Merged observations without provider, source, origin, raw breach record, value or score.
        field(
          :details,
          Crystalline::Nilable.new(Models::Shared::RiskDetails),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("details")}}
        )

        sig {
          params(
            score: ::Integer,
            band: Models::Shared::Band,
            recommendation: Models::Shared::Recommendation,
            confidence: Models::Shared::RiskConfidence,
            policy_version: ::String,
            reasons: T::Array[Models::Shared::RiskReason],
            coverage: Models::Shared::RiskCoverage,
            block: T.nilable(T::Boolean),
            block_threshold: T.nilable(::Integer),
            policy_basis: ::String,
            summary: T.nilable(Models::Shared::RiskSummary),
            details: T.nilable(Models::Shared::RiskDetails)
          )
            .void
        }
        def initialize(
          score:,
          band:,
          recommendation:,
          confidence:,
          policy_version:,
          reasons:,
          coverage:,
          block: nil,
          block_threshold: nil,
          policy_basis: "heuristic_unvalidated",
          summary: nil,
          details: nil
        )
          @score = score
          @band = band
          @recommendation = recommendation
          @confidence = confidence
          @policy_version = policy_version
          @reasons = reasons
          @coverage = coverage
          @block = block
          @block_threshold = block_threshold
          unless policy_basis == "heuristic_unvalidated"
            raise ArgumentError, "Invalid value for policy_basis"
          end

          @policy_basis = "heuristic_unvalidated"
          @summary = summary
          @details = details
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @score == other.score
          return false unless @band == other.band
          return false unless @recommendation == other.recommendation
          return false unless @confidence == other.confidence
          return false unless @policy_version == other.policy_version
          return false unless @reasons == other.reasons
          return false unless @coverage == other.coverage
          return false unless @block == other.block
          return false unless @block_threshold == other.block_threshold
          return false unless @policy_basis == other.policy_basis
          return false unless @summary == other.summary
          return false unless @details == other.details
          true
        end
      end
    end
  end
end
