# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The 202 answer of POST /v1/assessments/{assessment_id}/outcomes. A replay with the same Idempotency-Key and body answers the same record.
      class AssessmentOutcome
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned id of one recorded outcome: 'out_' and a 26-character Crockford base32 ULID. Unique within the workspace.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # Opaque, server-assigned assessment id: 'asm_' and a 26-character Crockford base32 ULID. Unique within the workspace; another workspace's assessment id answers 404.
        field(
          :assessment_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id"), required: true}}
        )
        # What the provider later learned about the assessed account. confirmed_abuse, account_takeover and chargeback report abuse; false_positive and legitimate withdraw an earlier abuse report of this workspace for the assessment; unknown is recorded only. Outcomes are append-only and the latest one recorded for an assessment wins.
        field(
          :outcome,
          Models::Shared::Outcome,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("outcome"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Outcome, false)
            }
          }
        )
        # When NoResponse first recorded the outcome.
        field(
          :received_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("received_at"), required: true}}
        )

        sig {
          params(id: ::String, assessment_id: ::String, outcome: Models::Shared::Outcome, received_at: ::String).void
        }
        def initialize(id:, assessment_id:, outcome:, received_at:)
          @id = id
          @assessment_id = assessment_id
          @outcome = outcome
          @received_at = received_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @assessment_id == other.assessment_id
          return false unless @outcome == other.outcome
          return false unless @received_at == other.received_at
          true
        end
      end
    end
  end
end
