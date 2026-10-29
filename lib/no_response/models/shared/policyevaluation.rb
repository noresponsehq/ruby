# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyEvaluation
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :environment,
          Models::Shared::AuditSettingsEnvironment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AuditSettingsEnvironment, false)
            }
          }
        )

        field(
          :status,
          Models::Shared::PolicyEvaluationStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::PolicyEvaluationStatus, false)
            }
          }
        )

        field(
          :policy_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("policy_version"), required: true}}
        )

        field(
          :scoring_policy,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("scoring_policy"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )

        field(
          :accounts,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("accounts"), required: true}}
        )

        field(
          :requests,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("requests"), required: true}}
        )

        field(
          :evaluator_sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evaluator_sha256"), required: true}}
        )

        field(
          :captured_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("captured_at")}}
        )

        field(
          :finished_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("finished_at")}}
        )

        field(
          :evaluator_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evaluator_version"), required: true}}
        )

        field(
          :build_version,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("build_version")}}
        )

        field(
          :result_status,
          Crystalline::Nilable.new(Models::Shared::ResultStatus),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("result_status"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ResultStatus, true)
            }
          }
        )

        field(
          :error_code,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("error_code")}}
        )

        field(
          :published_policy_version,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("published_policy_version")}}
        )

        field(
          :manifest_sha256,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("manifest_sha256")}}
        )

        field(
          :input_sha256,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("input_sha256")}}
        )

        field(
          :cohort_sha256,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("cohort_sha256")}}
        )

        field(
          :result_sha256,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("result_sha256")}}
        )

        sig {
          params(
            id: ::String,
            environment: Models::Shared::AuditSettingsEnvironment,
            status: Models::Shared::PolicyEvaluationStatus,
            policy_version: ::Integer,
            scoring_policy: ::String,
            created_at: ::String,
            expires_at: ::String,
            accounts: ::Integer,
            requests: ::Integer,
            evaluator_sha256: ::String,
            captured_at: T.nilable(::String),
            finished_at: T.nilable(::String),
            evaluator_version: ::String,
            build_version: T.nilable(::String),
            result_status: T.nilable(Models::Shared::ResultStatus),
            error_code: T.nilable(::String),
            published_policy_version: T.nilable(::Integer),
            manifest_sha256: T.nilable(::String),
            input_sha256: T.nilable(::String),
            cohort_sha256: T.nilable(::String),
            result_sha256: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          environment:,
          status:,
          policy_version:,
          scoring_policy:,
          created_at:,
          expires_at:,
          accounts:,
          requests:,
          evaluator_sha256:,
          captured_at: nil,
          finished_at: nil,
          evaluator_version: "identity-threshold-evaluator-v2",
          build_version: nil,
          result_status: nil,
          error_code: nil,
          published_policy_version: nil,
          manifest_sha256: nil,
          input_sha256: nil,
          cohort_sha256: nil,
          result_sha256: nil
        )
          @id = id
          @environment = environment
          @status = status
          @policy_version = policy_version
          @scoring_policy = scoring_policy
          @created_at = created_at
          @expires_at = expires_at
          @accounts = accounts
          @requests = requests
          @evaluator_sha256 = evaluator_sha256
          @captured_at = captured_at
          @finished_at = finished_at
          unless evaluator_version == "identity-threshold-evaluator-v2"
            raise ArgumentError, "Invalid value for evaluator_version"
          end

          @evaluator_version = "identity-threshold-evaluator-v2"
          @build_version = build_version
          @result_status = result_status
          @error_code = error_code
          @published_policy_version = published_policy_version
          @manifest_sha256 = manifest_sha256
          @input_sha256 = input_sha256
          @cohort_sha256 = cohort_sha256
          @result_sha256 = result_sha256
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @environment == other.environment
          return false unless @status == other.status
          return false unless @policy_version == other.policy_version
          return false unless @scoring_policy == other.scoring_policy
          return false unless @created_at == other.created_at
          return false unless @expires_at == other.expires_at
          return false unless @accounts == other.accounts
          return false unless @requests == other.requests
          return false unless @evaluator_sha256 == other.evaluator_sha256
          return false unless @captured_at == other.captured_at
          return false unless @finished_at == other.finished_at
          return false unless @evaluator_version == other.evaluator_version
          return false unless @build_version == other.build_version
          return false unless @result_status == other.result_status
          return false unless @error_code == other.error_code
          return false unless @published_policy_version == other.published_policy_version
          return false unless @manifest_sha256 == other.manifest_sha256
          return false unless @input_sha256 == other.input_sha256
          return false unless @cohort_sha256 == other.cohort_sha256
          return false unless @result_sha256 == other.result_sha256
          true
        end
      end
    end
  end
end
