# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class RecordAssessmentOutcomeRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Path segment, matched case-sensitively. A value that does not match the assessment_id shape answers 404, not 400.
        field(
          :assessment_id,
          ::String,
          {'path_param': {'field_name': "assessment_id", 'style': "simple", 'explode': false}}
        )
        # Opaque client key, 16 to 128 characters of [A-Za-z0-9._:-] (a UUID or ULID fits). Scoped to the tenant principal and bound to the canonical body for 24 hours.
        field(
          :idempotency_key,
          ::String,
          {'header': {'field_name': "Idempotency-Key", 'style': "simple", 'explode': false}}
        )

        field :body, Models::Shared::AssessmentOutcomeRequest, {'request': {'media_type': "application/json"}}

        sig {
          params(assessment_id: ::String, idempotency_key: ::String, body: Models::Shared::AssessmentOutcomeRequest)
            .void
        }
        def initialize(assessment_id:, idempotency_key:, body:)
          @assessment_id = assessment_id
          @idempotency_key = idempotency_key
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @assessment_id == other.assessment_id
          return false unless @idempotency_key == other.idempotency_key
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
