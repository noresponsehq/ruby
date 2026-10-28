# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class BindProvisionalAccountRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400.
        field(
          :assessment_id,
          ::String,
          {'path_param': {'field_name': "assessment_id", 'style': "simple", 'explode': false}}
        )

        field :body, Models::Shared::AccountBindingRequest, {'request': {'media_type': "application/json"}}

        sig { params(assessment_id: ::String, body: Models::Shared::AccountBindingRequest).void }
        def initialize(assessment_id:, body:)
          @assessment_id = assessment_id
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @assessment_id == other.assessment_id
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
