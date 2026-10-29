# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Immutable publication provenance remains in policy history after evaluation evidence expires. SHA-256 values identify the frozen manifest, evaluator semantic input, cohort, and canonical result separately.
      class Publication
        extend T::Sig
        include Crystalline::MetadataFields

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
          :cohort_sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("cohort_sha256"), required: true}}
        )

        field(
          :result_sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("result_sha256"), required: true}}
        )

        field(
          :evaluator_sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evaluator_sha256"), required: true}}
        )

        field(
          :evaluation_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evaluation_id"), required: true}}
        )

        field(
          :build_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("build_version"), required: true}}
        )

        field(
          :captured_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("captured_at"), required: true}}
        )

        field(
          :published_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("published_at"), required: true}}
        )

        field(
          :evaluator_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evaluator_version"), required: true}}
        )

        sig {
          params(
            manifest_sha256: ::String,
            input_sha256: ::String,
            cohort_sha256: ::String,
            result_sha256: ::String,
            evaluator_sha256: ::String,
            evaluation_id: ::String,
            build_version: ::String,
            captured_at: ::String,
            published_at: ::String,
            evaluator_version: ::String
          )
            .void
        }
        def initialize(
          manifest_sha256:,
          input_sha256:,
          cohort_sha256:,
          result_sha256:,
          evaluator_sha256:,
          evaluation_id:,
          build_version:,
          captured_at:,
          published_at:,
          evaluator_version: "identity-threshold-evaluator-v2"
        )
          @manifest_sha256 = manifest_sha256
          @input_sha256 = input_sha256
          @cohort_sha256 = cohort_sha256
          @result_sha256 = result_sha256
          @evaluator_sha256 = evaluator_sha256
          @evaluation_id = evaluation_id
          @build_version = build_version
          @captured_at = captured_at
          @published_at = published_at
          unless evaluator_version == "identity-threshold-evaluator-v2"
            raise ArgumentError, "Invalid value for evaluator_version"
          end

          @evaluator_version = "identity-threshold-evaluator-v2"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @manifest_sha256 == other.manifest_sha256
          return false unless @input_sha256 == other.input_sha256
          return false unless @cohort_sha256 == other.cohort_sha256
          return false unless @result_sha256 == other.result_sha256
          return false unless @evaluator_sha256 == other.evaluator_sha256
          return false unless @evaluation_id == other.evaluation_id
          return false unless @build_version == other.build_version
          return false unless @captured_at == other.captured_at
          return false unless @published_at == other.published_at
          return false unless @evaluator_version == other.evaluator_version
          true
        end
      end
    end
  end
end
