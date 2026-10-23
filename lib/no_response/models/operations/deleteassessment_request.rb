# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class DeleteAssessmentRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400.
        field(
          :assessment_id,
          ::String,
          {'path_param': {'field_name': "assessment_id", 'style': "simple", 'explode': false}}
        )

        sig { params(assessment_id: ::String).void }
        def initialize(assessment_id:)
          @assessment_id = assessment_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @assessment_id == other.assessment_id
          true
        end
      end
    end
  end
end
