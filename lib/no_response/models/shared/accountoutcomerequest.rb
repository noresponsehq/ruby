# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Record a factual report, not an enforcement action. A known outcome replaces the effective report. unknown alone records uncertainty without changing it; unknown with supersedes explicitly retracts it. supersedes must name the current effective report or the request answers 409 outcome_conflict. Reports remain append-only. Idempotency-Key is required. observed_at defaults to receipt time and cannot be over five minutes ahead.
      class AccountOutcomeRequest
        extend T::Sig
        include Crystalline::MetadataFields

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
          :observed_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("observed_at")}}
        )
        # Your own opaque reference for the outcome, such as a case or ticket id. Stored as given and not interpreted; keep direct identifiers out of it.
        field(
          :external_ref,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_ref")}}
        )
        # Opaque, server-assigned id of one recorded outcome: 'out_' and a 26-character Crockford base32 ULID. Unique within the workspace.
        field(
          :supersedes,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("supersedes")}}
        )

        sig {
          params(
            outcome: Models::Shared::Outcome,
            observed_at: T.nilable(::String),
            external_ref: T.nilable(::String),
            supersedes: T.nilable(::String)
          )
            .void
        }
        def initialize(outcome:, observed_at: nil, external_ref: nil, supersedes: nil)
          @outcome = outcome
          @observed_at = observed_at
          @external_ref = external_ref
          @supersedes = supersedes
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @outcome == other.outcome
          return false unless @observed_at == other.observed_at
          return false unless @external_ref == other.external_ref
          return false unless @supersedes == other.supersedes
          true
        end
      end
    end
  end
end
