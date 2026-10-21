# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class GetAssessmentRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400.
        field(
          :assessment_id,
          ::String,
          {'path_param': {'field_name': "assessment_id", 'style': "simple", 'explode': false}}
        )
        # Optional standard or separately authorised detailed customer view; raw is rejected.
        field(
          :response_mode,
          Crystalline::Nilable.new(Models::Shared::ResponseMode),
          {'query_param': {'field_name': "response_mode", 'style': "form", 'explode': true}}
        )

        sig { params(assessment_id: ::String, response_mode: T.nilable(Models::Shared::ResponseMode)).void }
        def initialize(assessment_id:, response_mode: nil)
          @assessment_id = assessment_id
          @response_mode = response_mode
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @assessment_id == other.assessment_id
          return false unless @response_mode == other.response_mode
          true
        end
      end
    end
  end
end
