# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AccountDirectoryPageItem
        extend T::Sig
        include Crystalline::MetadataFields

        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id} and its /assessments. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )
        # Retrieve a retained assessment version with its original decision, policy, flow and depth. This response excludes the current account decision. Current retention and response-mode permissions still apply.
        field(
          :latest,
          Models::Shared::AssessmentRevision,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("latest"), required: true}}
        )
        # Count of admitted retained assessments belonging to this account, not just the returned page.
        field(
          :assessments,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessments"), required: true}}
        )
        # Present for needs_action searches. outcome means a current review/block decision lacks a retained effective outcome; review means a retained open or in-progress review. Both can apply.
        field(
          :waiting_for,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::WaitingFor)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("waiting_for")}}
        )
        # Body of the 200 answer to GET /v1/accounts/{account_id}: the one current risk of one of the calling workspace's accounts. It is the risk of the account's latest assessment that has a decision (status complete or partial), by created_at and then assessment_id, scored exactly as GET /v1/assessments/{assessment_id} scores that assessment, plus the account's own reason shared_api_key when a key issued to the account was used from many IP addresses or countries (POST /v1/key_usage/batches). Its assessments are the account's history (GET /v1/accounts/{account_id}/assessments).
        field(
          :current,
          Crystalline::Nilable.new(Models::Shared::Account),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("current")}}
        )

        sig {
          params(
            account_id: ::String,
            latest: Models::Shared::AssessmentRevision,
            assessments: ::Integer,
            waiting_for: T.nilable(T::Array[Models::Shared::WaitingFor]),
            current: T.nilable(Models::Shared::Account)
          )
            .void
        }
        def initialize(account_id:, latest:, assessments:, waiting_for: nil, current: nil)
          @account_id = account_id
          @latest = latest
          @assessments = assessments
          @waiting_for = waiting_for
          @current = current
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @latest == other.latest
          return false unless @assessments == other.assessments
          return false unless @waiting_for == other.waiting_for
          return false unless @current == other.current
          true
        end
      end
    end
  end
end
