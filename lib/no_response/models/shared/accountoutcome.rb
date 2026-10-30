# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Immutable acceptance receipt. risk_version is the account version after this report committed, not the version when a retry reads it. effective_outcome_id names the effective head at that write. The effective expiration may shorten under retention changes. A legitimate report or correction removes only the account-feedback contribution, not unrelated risk.
      class AccountOutcome
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned id of one recorded outcome: 'out_' and a 26-character Crockford base32 ULID. Unique within the workspace.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id}, its /assessments and its /linked_accounts. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
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
          :observed_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("observed_at"), required: true}}
        )

        field(
          :received_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("received_at"), required: true}}
        )

        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )

        field(
          :actor,
          Models::Shared::AccountOutcomeActor,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("actor"), required: true}}
        )

        field(
          :risk_version_before,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("risk_version_before"), required: true}}
        )

        field(
          :risk_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("risk_version"), required: true}}
        )
        # Opaque, server-assigned id of one recorded outcome: 'out_' and a 26-character Crockford base32 ULID. Unique within the workspace.
        field(
          :supersedes,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("supersedes")}}
        )
        # Your own opaque reference for the outcome, such as a case or ticket id. Stored as given and not interpreted; keep direct identifiers out of it.
        field(
          :external_ref,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_ref")}}
        )
        # Opaque, server-assigned id of one recorded outcome: 'out_' and a 26-character Crockford base32 ULID. Unique within the workspace.
        field(
          :effective_outcome_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("effective_outcome_id")}}
        )

        sig {
          params(
            id: ::String,
            account_id: ::String,
            outcome: Models::Shared::Outcome,
            observed_at: ::String,
            received_at: ::String,
            expires_at: ::String,
            actor: Models::Shared::AccountOutcomeActor,
            risk_version_before: ::Integer,
            risk_version: ::Integer,
            supersedes: T.nilable(::String),
            external_ref: T.nilable(::String),
            effective_outcome_id: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          account_id:,
          outcome:,
          observed_at:,
          received_at:,
          expires_at:,
          actor:,
          risk_version_before:,
          risk_version:,
          supersedes: nil,
          external_ref: nil,
          effective_outcome_id: nil
        )
          @id = id
          @account_id = account_id
          @outcome = outcome
          @observed_at = observed_at
          @received_at = received_at
          @expires_at = expires_at
          @actor = actor
          @risk_version_before = risk_version_before
          @risk_version = risk_version
          @supersedes = supersedes
          @external_ref = external_ref
          @effective_outcome_id = effective_outcome_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @account_id == other.account_id
          return false unless @outcome == other.outcome
          return false unless @observed_at == other.observed_at
          return false unless @received_at == other.received_at
          return false unless @expires_at == other.expires_at
          return false unless @actor == other.actor
          return false unless @risk_version_before == other.risk_version_before
          return false unless @risk_version == other.risk_version
          return false unless @supersedes == other.supersedes
          return false unless @external_ref == other.external_ref
          return false unless @effective_outcome_id == other.effective_outcome_id
          true
        end
      end
    end
  end
end
