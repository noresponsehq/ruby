# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyEvaluationPublishRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :expected_policy_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_policy_version"), required: true}}
        )

        field(
          :manifest_sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("manifest_sha256"), required: true}}
        )

        field(
          :input_sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("input_sha256"), required: true}}
        )

        field(
          :result_sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("result_sha256"), required: true}}
        )

        field(
          :candidate,
          Models::Shared::Thresholds,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("candidate"), required: true}}
        )

        field(
          :change_reason,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("change_reason"), required: true}}
        )

        sig {
          params(
            expected_policy_version: ::Integer,
            manifest_sha256: ::String,
            input_sha256: ::String,
            result_sha256: ::String,
            candidate: Models::Shared::Thresholds,
            change_reason: ::String
          )
            .void
        }
        def initialize(
          expected_policy_version:,
          manifest_sha256:,
          input_sha256:,
          result_sha256:,
          candidate:,
          change_reason:
        )
          @expected_policy_version = expected_policy_version
          @manifest_sha256 = manifest_sha256
          @input_sha256 = input_sha256
          @result_sha256 = result_sha256
          @candidate = candidate
          @change_reason = change_reason
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @expected_policy_version == other.expected_policy_version
          return false unless @manifest_sha256 == other.manifest_sha256
          return false unless @input_sha256 == other.input_sha256
          return false unless @result_sha256 == other.result_sha256
          return false unless @candidate == other.candidate
          return false unless @change_reason == other.change_reason
          true
        end
      end
    end
  end
end
