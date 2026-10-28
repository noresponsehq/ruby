# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Retrieve the account decision at one recorded risk version. The answer uses the original assessment and account-specific risk inputs. Earlier versions that were not captured return 404. The assessment version, policy version and account calculation version identify the decision.
      class AccountDecisionSnapshot
        extend T::Sig
        include Crystalline::MetadataFields

        # Body of the 200 answer to GET /v1/accounts/{account_id}: the one current risk of one of the calling workspace's accounts. It is the risk of the account's latest assessment that has a decision (status complete or partial), by created_at and then assessment_id, scored exactly as GET /v1/assessments/{assessment_id} scores that assessment, plus the account's own reason shared_api_key when a key issued to the account was used from many IP addresses or countries (POST /v1/key_usage/batches). Its assessments are the account's history (GET /v1/accounts/{account_id}/assessments).
        field(
          :account,
          Models::Shared::Account,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account"), required: true}}
        )
        # Monotonic revision of this assessment. 1 on the synchronous answer; each material change while the assessment is served (an async continuation settling a source, a change of recommendation, confidence or status) increments it. Expiry does not increment it: an expired assessment is gone, not revised, and the expiry webhook carries the last served version.
        field(
          :assessment_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_version"), required: true}}
        )
        # Version of the hand-authored heuristic policy that produced the recommendation, for example 'risk-2026-10.7'. A workspace threshold override adds a +t<N> suffix, e.g. 'risk-2026-10.7+t3'.
        field(
          :policy_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("policy_version"), required: true}}
        )

        field(
          :changed_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("changed_at"), required: true}}
        )

        field(
          :overlay_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("overlay_version"), required: true}}
        )
        # Opaque, server-assigned id of one recorded outcome: 'out_' and a 26-character Crockford base32 ULID. Unique within the workspace.
        field(
          :feedback_outcome_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("feedback_outcome_id")}}
        )

        sig {
          params(
            account: Models::Shared::Account,
            assessment_version: ::Integer,
            policy_version: ::String,
            changed_at: ::String,
            overlay_version: ::Integer,
            feedback_outcome_id: T.nilable(::String)
          )
            .void
        }
        def initialize(
          account:,
          assessment_version:,
          policy_version:,
          changed_at:,
          overlay_version: 1,
          feedback_outcome_id: nil
        )
          @account = account
          @assessment_version = assessment_version
          @policy_version = policy_version
          @changed_at = changed_at
          unless overlay_version == 1
            raise ArgumentError, "Invalid value for overlay_version"
          end

          @overlay_version = 1
          @feedback_outcome_id = feedback_outcome_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account == other.account
          return false unless @assessment_version == other.assessment_version
          return false unless @policy_version == other.policy_version
          return false unless @changed_at == other.changed_at
          return false unless @overlay_version == other.overlay_version
          return false unless @feedback_outcome_id == other.feedback_outcome_id
          true
        end
      end
    end
  end
end
