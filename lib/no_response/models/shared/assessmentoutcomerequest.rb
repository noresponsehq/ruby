# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/assessments/{assessment_id}/outcomes body: what the provider later learned about the account it assessed. The assessment is named by the path and the workspace by the API key, so neither is a body member. Idempotency-Key is required and binds the body as it does on POST /v1/assessments.
      class AssessmentOutcomeRequest
        extend T::Sig
        include Crystalline::MetadataFields

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
        # When the provider observed the outcome. Defaults to when NoResponse received it.
        field(
          :observed_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("observed_at")}}
        )
        # Your own opaque reference for the outcome, such as a case or ticket id. Stored as given and not interpreted; keep direct identifiers out of it.
        field(
          :external_ref,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_ref")}}
        )
        # Free text for your own records, at most 500 characters. Stored only; it is left out of scoring and answers. Keep personal data out of it. Control characters other than tab and line breaks are refused.
        field(
          :notes,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("notes")}}
        )

        sig {
          params(
            outcome: Models::Shared::Outcome,
            observed_at: T.nilable(::String),
            external_ref: T.nilable(::String),
            notes: T.nilable(::String)
          )
            .void
        }
        def initialize(outcome:, observed_at: nil, external_ref: nil, notes: nil)
          @outcome = outcome
          @observed_at = observed_at
          @external_ref = external_ref
          @notes = notes
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @outcome == other.outcome
          return false unless @observed_at == other.observed_at
          return false unless @external_ref == other.external_ref
          return false unless @notes == other.notes
          true
        end
      end
    end
  end
end
