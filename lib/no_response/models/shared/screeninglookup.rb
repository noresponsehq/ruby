# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # What the signup check's lookups found for a person: account presence for the email, phone and usernames (the person's handles), the phone lookup, the email domain's registration and the breach search. Context and coverage for the reviewer, not a finding: nothing here sets a band or a match state.
      class ScreeningLookup
        extend T::Sig
        include Crystalline::MetadataFields

        # Each lane each identifier was looked up in, identifiers in the order email, phone, username and lanes in the order accounts, phone, breach, domain. Every lane the person's identifiers are looked up in is listed: one that no source answered, or that no source could be asked in, is not_covered. Empty when the person has no email, phone or handle to look up.
        field(
          :checks,
          Crystalline::Array.new(Models::Shared::ScreeningLookupCheck),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("checks"), required: true}}
        )
        # When the lookups ran.
        field(
          :looked_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("looked_at"), required: true}}
        )
        # A few typed facts per identifier: an assessment's risk.summary, and a screened person's lookup summary. Every fact is optional: absent means the evidence did not answer and makes no claim, while false or 0 is a definite answer.
        field(
          :summary,
          Crystalline::Nilable.new(Models::Shared::RiskSummary),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("summary")}}
        )
        # Merged observations behind the summary, served only to a caller who may read evidence: no provider, source, origin, raw breach record or score.
        field(
          :details,
          Crystalline::Nilable.new(Models::Shared::RiskDetails),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("details")}}
        )

        sig {
          params(
            checks: T::Array[Models::Shared::ScreeningLookupCheck],
            looked_at: ::String,
            summary: T.nilable(Models::Shared::RiskSummary),
            details: T.nilable(Models::Shared::RiskDetails)
          )
            .void
        }
        def initialize(checks:, looked_at:, summary: nil, details: nil)
          @checks = checks
          @looked_at = looked_at
          @summary = summary
          @details = details
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @checks == other.checks
          return false unless @looked_at == other.looked_at
          return false unless @summary == other.summary
          return false unless @details == other.details
          true
        end
      end
    end
  end
end
