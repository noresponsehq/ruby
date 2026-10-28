# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class GetAssessmentVersionRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400.
        field(
          :assessment_id,
          ::String,
          {'path_param': {'field_name': "assessment_id", 'style': "simple", 'explode': false}}
        )
        # The stored assessment_version, in canonical decimal form. An unavailable or malformed version answers 404.
        field :version, ::Integer, {'path_param': {'field_name': "version", 'style': "simple", 'explode': false}}
        # Optional standard or separately authorised detailed customer view; raw is rejected.
        field(
          :response_mode,
          Crystalline::Nilable.new(Models::Shared::ResponseMode),
          {'query_param': {'field_name': "response_mode", 'style': "form", 'explode': true}}
        )

        sig {
          params(assessment_id: ::String, version: ::Integer, response_mode: T.nilable(Models::Shared::ResponseMode))
            .void
        }
        def initialize(assessment_id:, version:, response_mode: nil)
          @assessment_id = assessment_id
          @version = version
          @response_mode = response_mode
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @assessment_id == other.assessment_id
          return false unless @version == other.version
          return false unless @response_mode == other.response_mode
          true
        end
      end
    end
  end
end
