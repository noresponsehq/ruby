# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The evaluation report and its provenance. A no_change report cannot authorise publication.
      class PolicyEvaluationResult
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :evaluation,
          Models::Shared::PolicyEvaluation,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evaluation"), required: true}}
        )

        field(
          :report,
          Models::Shared::Report,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("report"), required: true}}
        )

        sig { params(evaluation: Models::Shared::PolicyEvaluation, report: Models::Shared::Report).void }
        def initialize(evaluation:, report:)
          @evaluation = evaluation
          @report = report
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @evaluation == other.evaluation
          return false unless @report == other.report
          true
        end
      end
    end
  end
end
