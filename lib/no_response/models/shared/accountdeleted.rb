# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Terminal for the account's assessments created at or before deleted_at in the receiving endpoint's environment: delete what you hold from them and ignore later-arriving updates of them. deleted_at is no earlier than the creation of any assessment it erased. An assessment created after it belongs to the account assessed again: keep it, even when this event arrives after it.
      class AccountDeleted
        extend T::Sig
        include Crystalline::MetadataFields

        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id}, its /assessments and its /linked_accounts. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )
        # How many assessments the erasure deleted.
        field(
          :assessments_deleted,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessments_deleted"), required: true}}
        )
        # When the erasure took effect, equal to deleted_at in the DELETE answer.
        field(
          :deleted_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("deleted_at"), required: true}}
        )

        sig { params(account_id: ::String, assessments_deleted: ::Integer, deleted_at: ::String).void }
        def initialize(account_id:, assessments_deleted:, deleted_at:)
          @account_id = account_id
          @assessments_deleted = assessments_deleted
          @deleted_at = deleted_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @assessments_deleted == other.assessments_deleted
          return false unless @deleted_at == other.deleted_at
          true
        end
      end
    end
  end
end
