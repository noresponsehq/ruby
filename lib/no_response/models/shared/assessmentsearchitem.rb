# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One stored assessment revision, exactly as GET /v1/assessments/{assessment_id}/versions/{version} returns it, with the decision of the assessment's first answer. It is not re-scored and carries no current account risk.
      class AssessmentSearchItem
        extend T::Sig
        include Crystalline::MetadataFields

        # This assessment's id, equal to detail.assessment_id.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # Processing state, separate from evidence coverage. complete: final; nothing is still running, but unsupported, failed or unanswered lanes remain in incomplete_sources. partial: a recommendation exists and evidence is incomplete; assessment_url identifies continuing work when present. pending: no recommendation yet; poll or wait for the webhook. Finished processing does not mean all sources answered.
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
        # An assessment's own decision: block when its stored risk.block is true, otherwise its recommendation. It is not the account's decision or held-admission state.
        field(
          :first_decision,
          Crystalline::Nilable.new(Models::Shared::Decision),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("first_decision"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Decision, true)
            }
          }
        )
        # Why this result matched a typed identifier search. value is the original value submitted in assessment_id. Provenance records a customer submission, not a source discovery or verified ownership. Equality is deterministic and has no inferred confidence score. An account result names its newest retained matching assessment, which can differ from latest.
        field(
          :matched_identifier,
          Crystalline::Nilable.new(Models::Shared::IdentifierMatch),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("matched_identifier")}}
        )

        sig {
          params(
            id: ::String,
            status: Models::Shared::Status,
            flow: Models::Shared::Flow,
            depth: Models::Shared::Depth,
            detail: Models::Shared::AssessmentDetail,
            schema_version: ::String,
            first_decision: T.nilable(Models::Shared::Decision),
            matched_identifier: T.nilable(Models::Shared::IdentifierMatch)
          )
            .void
        }
        def initialize(
          id:,
          status:,
          flow:,
          depth:,
          detail:,
          schema_version: "1",
          first_decision: nil,
          matched_identifier: nil
        )
          @id = id
          @status = status
          @flow = flow
          @depth = depth
          @detail = detail
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
          @first_decision = first_decision
          @matched_identifier = matched_identifier
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
          return false unless @first_decision == other.first_decision
          return false unless @matched_identifier == other.matched_identifier
          true
        end
      end
    end
  end
end
