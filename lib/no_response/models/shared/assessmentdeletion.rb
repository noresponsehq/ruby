# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Body of the 200 answer to DELETE /v1/assessments/{assessment_id}: one of the calling workspace's assessments was deleted, with its versions, evidence, outcomes and the identity-graph marks its outcomes set. Afterwards GET /v1/assessments/{assessment_id} answers 404 and the assessment leaves the account's history. The account is scored again from what remains: account.current_assessment_id names the assessment GET /v1/accounts/{account_id} now serves its risk from, and is absent when the account has no assessment with a decision left. Deleting an assessment that is already gone answers 404.
      class AssessmentDeletion
        extend T::Sig
        include Crystalline::MetadataFields

        # The assessment that was deleted.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :account,
          Models::Shared::AssessmentDeletionAccount,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account"), required: true}}
        )
        # When the deletion took effect.
        field(
          :deleted_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("deleted_at"), required: true}}
        )
        # Version of the body shape.
        field(
          :schema_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schema_version"), required: true}}
        )

        field(
          :deleted,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("deleted"), required: true}}
        )
        # Receipt for GET /v1/erasures/{erasure_id}, when durable storage issued one.
        field(
          :erasure_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("erasure_id")}}
        )

        sig {
          params(
            id: ::String,
            account: Models::Shared::AssessmentDeletionAccount,
            deleted_at: ::String,
            schema_version: ::String,
            deleted: T::Boolean,
            erasure_id: T.nilable(::String)
          )
            .void
        }
        def initialize(id:, account:, deleted_at:, schema_version: "1", deleted: true, erasure_id: nil)
          @id = id
          @account = account
          @deleted_at = deleted_at
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
          unless deleted == true
            raise ArgumentError, "Invalid value for deleted"
          end

          @deleted = true
          @erasure_id = erasure_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @account == other.account
          return false unless @deleted_at == other.deleted_at
          return false unless @schema_version == other.schema_version
          return false unless @deleted == other.deleted
          return false unless @erasure_id == other.erasure_id
          true
        end
      end
    end
  end
end
