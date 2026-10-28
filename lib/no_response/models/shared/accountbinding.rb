# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Binding appends an assessment revision and preserves earlier versions. Continuations use the same assessment. Erasing either the provisional or canonical name erases the canonical account, including the bound assessment.
      class AccountBinding
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned assessment id: 'asm_' and a 26-character Crockford base32 ULID. Unique within the workspace; another workspace's assessment id answers 404.
        field(
          :assessment_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id"), required: true}}
        )
        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id} and its /assessments. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :provisional_account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("provisional_account_id"), required: true}}
        )
        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id} and its /assessments. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )
        # Monotonic revision of this assessment. 1 on the synchronous answer; each material change while the assessment is served (an async continuation settling a source, a change of recommendation, confidence or status) increments it. Expiry does not increment it: an expired assessment is gone, not revised, and the expiry webhook carries the last served version.
        field(
          :assessment_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_version"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :actor,
          Models::Shared::AccountBindingActor,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("actor"), required: true}}
        )

        sig {
          params(
            assessment_id: ::String,
            provisional_account_id: ::String,
            account_id: ::String,
            assessment_version: ::Integer,
            created_at: ::String,
            actor: Models::Shared::AccountBindingActor
          )
            .void
        }
        def initialize(assessment_id:, provisional_account_id:, account_id:, assessment_version:, created_at:, actor:)
          @assessment_id = assessment_id
          @provisional_account_id = provisional_account_id
          @account_id = account_id
          @assessment_version = assessment_version
          @created_at = created_at
          @actor = actor
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @assessment_id == other.assessment_id
          return false unless @provisional_account_id == other.provisional_account_id
          return false unless @account_id == other.account_id
          return false unless @assessment_version == other.assessment_version
          return false unless @created_at == other.created_at
          return false unless @actor == other.actor
          true
        end
      end
    end
  end
end
