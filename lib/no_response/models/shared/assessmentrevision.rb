# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Retrieve a retained assessment version with its original decision, policy, flow and depth. This response excludes the current account decision. Current retention and response-mode permissions still apply.
      class AssessmentRevision
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

        sig {
          params(
            id: ::String,
            status: Models::Shared::Status,
            flow: Models::Shared::Flow,
            depth: Models::Shared::Depth,
            detail: Models::Shared::AssessmentDetail,
            schema_version: ::String
          )
            .void
        }
        def initialize(id:, status:, flow:, depth:, detail:, schema_version: "1")
          @id = id
          @status = status
          @flow = flow
          @depth = depth
          @detail = detail
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
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
          true
        end
      end
    end
  end
end
