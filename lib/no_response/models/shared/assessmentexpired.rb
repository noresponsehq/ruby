# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Terminal. Nothing to fetch; the consumer deletes its state for assessment_id.
      class AssessmentExpired
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned assessment id: 'asm_' and a 26-character Crockford base32 ULID. Unique within the workspace; another workspace's assessment id answers 404.
        field(
          :assessment_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id"), required: true}}
        )
        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id}, its /assessments and its /linked_accounts. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )
        # The last served version: expiry is not a revision.
        field(
          :assessment_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_version"), required: true}}
        )

        field(
          :status,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("status"), required: true}}
        )

        field(
          :change_reason,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("change_reason"), required: true}}
        )

        sig {
          params(
            assessment_id: ::String,
            account_id: ::String,
            assessment_version: ::Integer,
            status: ::String,
            change_reason: ::String
          )
            .void
        }
        def initialize(assessment_id:, account_id:, assessment_version:, status: "expired", change_reason: "expired")
          @assessment_id = assessment_id
          @account_id = account_id
          @assessment_version = assessment_version
          unless status == "expired"
            raise ArgumentError, "Invalid value for status"
          end

          @status = "expired"
          unless change_reason == "expired"
            raise ArgumentError, "Invalid value for change_reason"
          end

          @change_reason = "expired"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @assessment_id == other.assessment_id
          return false unless @account_id == other.account_id
          return false unless @assessment_version == other.assessment_version
          return false unless @status == other.status
          return false unless @change_reason == other.change_reason
          true
        end
      end
    end
  end
end
