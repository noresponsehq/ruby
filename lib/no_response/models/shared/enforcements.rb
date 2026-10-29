# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Retained customer enforcement report rows created in [from,to), one row per account/risk_version/flow/action. A later applied report can replace failed at the original created_at; retries are not additional attempts here. applied_coverage divides reported_applied by report rows, including explicit action none; it is not independently verified execution, all requested actions, or prevented fraud. Unreported actions are unknown.
      class Enforcements
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :denominator,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("denominator"), required: true}}
        )

        field(
          :accounts,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("accounts"), required: true}}
        )

        field(
          :reported_applied,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reported_applied"), required: true}}
        )

        field(
          :reported_failed,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reported_failed"), required: true}}
        )
        # Counts only; a zero denominator means no eligible retained records and does not imply a zero rate.
        field(
          :applied_coverage,
          Models::Shared::Coverage,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("applied_coverage"), required: true}}
        )

        field(
          :population,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("population"), required: true}}
        )

        sig {
          params(
            denominator: ::Integer,
            accounts: ::Integer,
            reported_applied: ::Integer,
            reported_failed: ::Integer,
            applied_coverage: Models::Shared::Coverage,
            population: ::String
          )
            .void
        }
        def initialize(
          denominator:,
          accounts:,
          reported_applied:,
          reported_failed:,
          applied_coverage:,
          population: "retained_enforcement_reports_by_created_at"
        )
          @denominator = denominator
          @accounts = accounts
          @reported_applied = reported_applied
          @reported_failed = reported_failed
          @applied_coverage = applied_coverage
          unless population == "retained_enforcement_reports_by_created_at"
            raise ArgumentError, "Invalid value for population"
          end

          @population = "retained_enforcement_reports_by_created_at"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @denominator == other.denominator
          return false unless @accounts == other.accounts
          return false unless @reported_applied == other.reported_applied
          return false unless @reported_failed == other.reported_failed
          return false unless @applied_coverage == other.applied_coverage
          return false unless @population == other.population
          true
        end
      end
    end
  end
end
