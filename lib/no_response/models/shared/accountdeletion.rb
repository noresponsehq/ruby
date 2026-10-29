# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Body of the 200 answer to DELETE /v1/accounts/{account_id}: the calling workspace's account was erased in the environment of the calling key. Every assessment of the account went, with its revisions, evidence, outcomes and the identity-graph marks its outcomes set, and an assessment that was still running when the call arrived is stopped. Afterwards GET /v1/accounts/{account_id} and GET /v1/assessments/{assessment_id} of each erased assessment answer 404, and the history page is empty. The call is idempotent: a repeat, or an account with nothing to erase, answers 200 with assessments_deleted 0. The account_id can be assessed again later, as a new account.
      class AccountDeletion
        extend T::Sig
        include Crystalline::MetadataFields

        # The account_id that was erased.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # How many assessments this call deleted. 0 when the account had none left, so a repeat answers 0.
        field(
          :assessments_deleted,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessments_deleted"), required: true}}
        )
        # When the erasure took effect. An assessment of the account begun before this time is refused or stopped.
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
            assessments_deleted: ::Integer,
            deleted_at: ::String,
            schema_version: ::String,
            deleted: T::Boolean,
            erasure_id: T.nilable(::String)
          )
            .void
        }
        def initialize(id:, assessments_deleted:, deleted_at:, schema_version: "1", deleted: true, erasure_id: nil)
          @id = id
          @assessments_deleted = assessments_deleted
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
          return false unless @assessments_deleted == other.assessments_deleted
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
