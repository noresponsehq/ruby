# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Body of the 200 answer to GET /v1/accounts/{account_id}: the one current risk of one of the calling workspace's accounts. It is the risk of the account's latest assessment that has a decision (status complete or partial), by created_at and then assessment_id, scored exactly as GET /v1/assessments/{assessment_id} scores that assessment, plus the account's own reason shared_api_key when a key issued to the account was used from many IP addresses or countries (POST /v1/key_usage/batches). Its assessments are the account's history (GET /v1/accounts/{account_id}/assessments).
      class Account
        extend T::Sig
        include Crystalline::MetadataFields

        # The account_id the workspace sends with its assessments.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :risk,
          Models::Shared::AccountRisk,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("risk"), required: true}}
        )
        # The decision for each flow: the account's score under that flow's thresholds. A flow the workspace has not set uses its account_creation thresholds, so the flows differ only where it set them.
        field(
          :decisions_by_flow,
          Models::Shared::AccountDecisionsByFlow,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decisions_by_flow"), required: true}}
        )
        # The assessment the current risk comes from.
        field(
          :assessment_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id"), required: true}}
        )
        # updated_at of that assessment's latest revision.
        field(
          :updated_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_at"), required: true}}
        )
        # The version of the account's current risk. It increases every time the account's current risk or decisions_by_flow changes, and does not decrease. Of two copies of an account, the one with the higher risk_version is newer. account.risk_changed carries the risk_version that its change made.
        field(
          :risk_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("risk_version"), required: true}}
        )
        # Version of the body shape.
        field(
          :schema_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schema_version"), required: true}}
        )

        sig {
          params(
            id: ::String,
            risk: Models::Shared::AccountRisk,
            decisions_by_flow: Models::Shared::AccountDecisionsByFlow,
            assessment_id: ::String,
            updated_at: ::String,
            risk_version: ::Integer,
            schema_version: ::String
          )
            .void
        }
        def initialize(id:, risk:, decisions_by_flow:, assessment_id:, updated_at:, risk_version:, schema_version: "1")
          @id = id
          @risk = risk
          @decisions_by_flow = decisions_by_flow
          @assessment_id = assessment_id
          @updated_at = updated_at
          @risk_version = risk_version
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @risk == other.risk
          return false unless @decisions_by_flow == other.decisions_by_flow
          return false unless @assessment_id == other.assessment_id
          return false unless @updated_at == other.updated_at
          return false unless @risk_version == other.risk_version
          return false unless @schema_version == other.schema_version
          true
        end
      end
    end
  end
end
