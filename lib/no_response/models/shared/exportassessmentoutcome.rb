# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Structured fields of a retained per-assessment outcome. Legacy notes remain private as promised by the existing outcome contract.
      class ExportAssessmentOutcome
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

        field(
          :observed_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("observed_at"), required: true}}
        )

        field(
          :received_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("received_at"), required: true}}
        )
        # Your own opaque reference for the outcome, such as a case or ticket id. Stored as given and not interpreted; keep direct identifiers out of it.
        field(
          :external_ref,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_ref")}}
        )

        sig {
          params(
            id: ::String,
            assessment_id: ::String,
            outcome: Models::Shared::Outcome,
            observed_at: ::String,
            received_at: ::String,
            external_ref: T.nilable(::String)
          )
            .void
        }
        def initialize(id:, assessment_id:, outcome:, observed_at:, received_at:, external_ref: nil)
          @id = id
          @assessment_id = assessment_id
          @outcome = outcome
          @observed_at = observed_at
          @received_at = received_at
          @external_ref = external_ref
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @assessment_id == other.assessment_id
          return false unless @outcome == other.outcome
          return false unless @observed_at == other.observed_at
          return false unless @received_at == other.received_at
          return false unless @external_ref == other.external_ref
          true
        end
      end
    end
  end
end
