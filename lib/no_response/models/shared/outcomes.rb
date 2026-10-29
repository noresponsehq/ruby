# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Accounts whose current completed assessment was created in the selected window and remains retained at as_of. The effective account feedback head is observed at as_of, including explicit unknown reports. Customer-reported labels and unlabelled accounts have separate counts. Superseded labels are excluded.
      class Outcomes
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :denominator,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("denominator"), required: true}}
        )

        field(
          :reported,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reported"), required: true}}
        )

        field(
          :unreported,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unreported"), required: true}}
        )
        # Counts only; a zero denominator means no eligible retained records and does not imply a zero rate.
        field(
          :label_coverage,
          Models::Shared::Coverage,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("label_coverage"), required: true}}
        )
        # Current customer-reported labels, not independently established ground truth. Missing keys mean zero. Unknown is an explicit report; absent or expired feedback is unreported.
        field(
          :by_outcome,
          Models::Shared::OutcomesByOutcome,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("by_outcome"), required: true}}
        )

        field(
          :population,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("population"), required: true}}
        )

        sig {
          params(
            denominator: ::Integer,
            reported: ::Integer,
            unreported: ::Integer,
            label_coverage: Models::Shared::Coverage,
            by_outcome: Models::Shared::OutcomesByOutcome,
            population: ::String
          )
            .void
        }
        def initialize(
          denominator:,
          reported:,
          unreported:,
          label_coverage:,
          by_outcome:,
          population: "retained_current_accounts_by_current_assessment_created_at"
        )
          @denominator = denominator
          @reported = reported
          @unreported = unreported
          @label_coverage = label_coverage
          @by_outcome = by_outcome
          unless population == "retained_current_accounts_by_current_assessment_created_at"
            raise ArgumentError, "Invalid value for population"
          end

          @population = "retained_current_accounts_by_current_assessment_created_at"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @denominator == other.denominator
          return false unless @reported == other.reported
          return false unless @unreported == other.unreported
          return false unless @label_coverage == other.label_coverage
          return false unless @by_outcome == other.by_outcome
          return false unless @population == other.population
          true
        end
      end
    end
  end
end
