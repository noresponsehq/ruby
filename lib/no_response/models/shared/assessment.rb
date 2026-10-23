# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One assessment, as POST /v1/assessments, GET /v1/assessments/{assessment_id} and the assessment.updated webhook return it. account is the account's one current risk: its score, the decision for this assessment's flow, the reasons and the decision for each flow. detail holds this assessment's own facts. status says whether the assessment is final (complete), usable with a source still running (partial) or not yet usable (pending). While the account's first assessment is pending, account is absent; wait for the webhook or poll the assessment. Keep the highest detail.assessment_version.
      class Assessment
        extend T::Sig
        include Crystalline::MetadataFields

        # This assessment's id, equal to detail.assessment_id.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # complete: final; nothing is still running. A lane that failed or missed its 10 s deadline stays listed in incomplete_sources, and confidence is lower. partial: a recommendation exists and at least one lane is still running or did not settle (see incomplete_sources). pending: nothing usable before the deadline; no recommendation yet, poll or wait for the webhook.
        field(
          :status,
          Models::Shared::Status,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Status, false)
            }
          }
        )
        # The event an assessment is made for: account_creation (a user creates an account), login (a user returns to an existing account) or purchase (a payment or a credit grant). The account's risk is reported with the decision for this flow.
        field(
          :flow,
          Models::Shared::Flow,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("flow"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Flow, false)
            }
          }
        )
        # How long the synchronous answer waits for sources. quick waits only for the fast sources, those that answer within 500 ms of ingress (or deadline_ms when lower); full waits for the whole budget, up to 3000 ms. Sources still running at the cut continue asynchronously and update the assessment either way.
        field(
          :depth,
          Models::Shared::Depth,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("depth"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Depth, false)
            }
          }
        )
        # One assessment's own facts: its score and recommendation, the signals behind them, the lanes still running and its timing. risk here is this assessment's own score; the account's current risk is the account member of the assessment. risk and recommendation are present for complete and partial; assessment_url is present for pending.
        field(
          :detail,
          Models::Shared::AssessmentDetail,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("detail"), required: true}}
        )
        # Version of the body shape.
        field(
          :schema_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schema_version"), required: true}}
        )
        # Body of the 200 answer to GET /v1/accounts/{account_id}: the one current risk of one of the calling workspace's accounts. It is the risk of the account's latest assessment that has a decision (status complete or partial), by created_at and then assessment_id, scored exactly as GET /v1/assessments/{assessment_id} scores that assessment, plus the account's own reason shared_api_key when a key issued to the account was used from many IP addresses or countries (POST /v1/key_usage/batches). Its assessments are the account's history (GET /v1/accounts/{account_id}/assessments).
        field(
          :account,
          Crystalline::Nilable.new(Models::Shared::Account),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account")}}
        )

        sig {
          params(
            id: ::String,
            status: Models::Shared::Status,
            flow: Models::Shared::Flow,
            depth: Models::Shared::Depth,
            detail: Models::Shared::AssessmentDetail,
            schema_version: ::String,
            account: T.nilable(Models::Shared::Account)
          )
            .void
        }
        def initialize(id:, status:, flow:, depth:, detail:, schema_version: "1", account: nil)
          @id = id
          @status = status
          @flow = flow
          @depth = depth
          @detail = detail
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
          @account = account
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @status == other.status
          return false unless @flow == other.flow
          return false unless @depth == other.depth
          return false unless @detail == other.detail
          return false unless @schema_version == other.schema_version
          return false unless @account == other.account
          true
        end
      end
    end
  end
end
