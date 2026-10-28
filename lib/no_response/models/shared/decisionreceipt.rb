# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The decision prepared for one HTTP attempt. Its account field preserves the account decision returned for that attempt, even after subsequent changes.
      class DecisionReceipt
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned assessment id: 'asm_' and a 26-character Crockford base32 ULID. Unique within the workspace; another workspace's assessment id answers 404.
        field(
          :assessment_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id"), required: true}}
        )
        # Monotonic revision of this assessment. 1 on the synchronous answer; each material change while the assessment is served (an async continuation settling a source, a change of recommendation, confidence or status) increments it. Expiry does not increment it: an expired assessment is gone, not revised, and the expiry webhook carries the last served version.
        field(
          :assessment_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_version"), required: true}}
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
        # Version of the hand-authored heuristic policy that produced the recommendation, for example 'risk-2026-10.7'. A workspace threshold override adds a +t<N> suffix, e.g. 'risk-2026-10.7+t3'.
        field(
          :policy_version,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("policy_version")}}
        )

        field(
          :score,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score")}}
        )
        # Body of the 200 answer to GET /v1/accounts/{account_id}: the one current risk of one of the calling workspace's accounts. It is the risk of the account's latest assessment that has a decision (status complete or partial), by created_at and then assessment_id, scored exactly as GET /v1/assessments/{assessment_id} scores that assessment, plus the account's own reason shared_api_key when a key issued to the account was used from many IP addresses or countries (POST /v1/key_usage/batches). Its assessments are the account's history (GET /v1/accounts/{account_id}/assessments).
        field(
          :account,
          Crystalline::Nilable.new(Models::Shared::Account),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account")}}
        )

        sig {
          params(
            assessment_id: ::String,
            assessment_version: ::Integer,
            flow: Models::Shared::Flow,
            status: Models::Shared::Status,
            policy_version: T.nilable(::String),
            score: T.nilable(::Integer),
            account: T.nilable(Models::Shared::Account)
          )
            .void
        }
        def initialize(
          assessment_id:,
          assessment_version:,
          flow:,
          status:,
          policy_version: nil,
          score: nil,
          account: nil
        )
          @assessment_id = assessment_id
          @assessment_version = assessment_version
          @flow = flow
          @status = status
          @policy_version = policy_version
          @score = score
          @account = account
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @assessment_id == other.assessment_id
          return false unless @assessment_version == other.assessment_version
          return false unless @flow == other.flow
          return false unless @status == other.status
          return false unless @policy_version == other.policy_version
          return false unless @score == other.score
          return false unless @account == other.account
          true
        end
      end
    end
  end
end
