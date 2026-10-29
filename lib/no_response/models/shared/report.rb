# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Report
        extend T::Sig
        include Crystalline::MetadataFields

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
          :status,
          Models::Shared::ResultStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ResultStatus, false)
            }
          }
        )

        field(
          :candidate,
          Models::Shared::Thresholds,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("candidate"), required: true}}
        )

        field(
          :scope,
          Models::Shared::ReportScope,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("scope"), required: true}}
        )

        field(
          :evaluator_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evaluator_version"), required: true}}
        )

        sig {
          params(
            input_sha256: ::String,
            cohort_sha256: ::String,
            status: Models::Shared::ResultStatus,
            candidate: Models::Shared::Thresholds,
            scope: Models::Shared::ReportScope,
            evaluator_version: ::String
          )
            .void
        }
        def initialize(
          input_sha256:,
          cohort_sha256:,
          status:,
          candidate:,
          scope:,
          evaluator_version: "identity-threshold-evaluator-v2"
        )
          @input_sha256 = input_sha256
          @cohort_sha256 = cohort_sha256
          @status = status
          @candidate = candidate
          @scope = scope
          unless evaluator_version == "identity-threshold-evaluator-v2"
            raise ArgumentError, "Invalid value for evaluator_version"
          end

          @evaluator_version = "identity-threshold-evaluator-v2"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @input_sha256 == other.input_sha256
          return false unless @cohort_sha256 == other.cohort_sha256
          return false unless @status == other.status
          return false unless @candidate == other.candidate
          return false unless @scope == other.scope
          return false unless @evaluator_version == other.evaluator_version
          true
        end
      end
    end
  end
end
