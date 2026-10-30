# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class IdentifierSubmission
        extend T::Sig
        include Crystalline::MetadataFields

        # The original value submitted in assessment_id. Under canonical or mailbox matching the two accounts' values can differ.
        field(
          :value,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value"), required: true}}
        )
        # Opaque, server-assigned assessment id: 'asm_' and a 26-character Crockford base32 ULID. Unique within the workspace; another workspace's assessment id answers 404.
        field(
          :assessment_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id"), required: true}}
        )
        # When assessment_id was created.
        field(
          :submitted_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("submitted_at"), required: true}}
        )

        sig { params(value: ::String, assessment_id: ::String, submitted_at: ::String).void }
        def initialize(value:, assessment_id:, submitted_at:)
          @value = value
          @assessment_id = assessment_id
          @submitted_at = submitted_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @value == other.value
          return false unless @assessment_id == other.assessment_id
          return false unless @submitted_at == other.submitted_at
          true
        end
      end
    end
  end
end
