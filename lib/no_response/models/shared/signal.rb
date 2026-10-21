# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Signal
        extend T::Sig
        include Crystalline::MetadataFields

        # Signal kind, for example account_presence or breach_exposure. New kinds may appear; ignore any you do not know.
        field :type, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("type"), required: true}}
        # Which submitted identifier a signal concerns. ip is a selector of breach_exposure only.
        field(
          :identifier,
          Models::Shared::IdentifierKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("identifier"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::IdentifierKind, false)
            }
          }
        )
        # Per-signal outcome. A source that timed out, was blocked or errored reports blocked, unavailable or inconclusive with a reason and is listed in incomplete_sources; not_found is a definite absence.
        field(
          :outcome,
          Models::Shared::SignalOutcome,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("outcome"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::SignalOutcome, false)
            }
          }
        )
        # Opaque, tenant-scoped projection of the source that produced a signal. It stays stable for your tenant while the projection key is unchanged and reveals no upstream provider, feed, breach table or source record.
        field(
          :source_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("source_id"), required: true}}
        )
        # Freshness class of the evidence behind a signal. unknown whenever no evidence was obtained.
        field(
          :freshness,
          Models::Shared::Freshness,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("freshness"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Freshness, false)
            }
          }
        )
        # Why a signal or source did not produce a definite found/not_found. timed_out means the source missed the request deadline; a continuation may still settle it. deferred means the (source, identifier) pair is async-only and was not attempted on the synchronous path; a continuation settles it.
        field(
          :reason,
          Crystalline::Nilable.new(Models::Shared::FailureReason),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("reason"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::FailureReason, true)
            }
          }
        )
        # Opaque pointer to evidence NoResponse holds for this signal. It carries no breach value, credential or page body.
        field(
          :evidence_ref,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evidence_ref")}}
        )
        # When the evidence was first observed.
        field(
          :observed_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("observed_at")}}
        )
        # When the source was last queried for this identifier.
        field(
          :last_checked_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("last_checked_at")}}
        )
        # Facts about the number only: line type, carrier and country. The upstream provider, its scores and its verdicts stay internal.
        field(
          :enrichment,
          Crystalline::Nilable.new(Models::Shared::PhoneEnrichment),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("enrichment")}}
        )

        sig {
          params(
            type: ::String,
            identifier: Models::Shared::IdentifierKind,
            outcome: Models::Shared::SignalOutcome,
            source_id: ::String,
            freshness: Models::Shared::Freshness,
            reason: T.nilable(Models::Shared::FailureReason),
            evidence_ref: T.nilable(::String),
            observed_at: T.nilable(::String),
            last_checked_at: T.nilable(::String),
            enrichment: T.nilable(Models::Shared::PhoneEnrichment)
          )
            .void
        }
        def initialize(
          type:,
          identifier:,
          outcome:,
          source_id:,
          freshness:,
          reason: nil,
          evidence_ref: nil,
          observed_at: nil,
          last_checked_at: nil,
          enrichment: nil
        )
          @type = type
          @identifier = identifier
          @outcome = outcome
          @source_id = source_id
          @freshness = freshness
          @reason = reason
          @evidence_ref = evidence_ref
          @observed_at = observed_at
          @last_checked_at = last_checked_at
          @enrichment = enrichment
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @type == other.type
          return false unless @identifier == other.identifier
          return false unless @outcome == other.outcome
          return false unless @source_id == other.source_id
          return false unless @freshness == other.freshness
          return false unless @reason == other.reason
          return false unless @evidence_ref == other.evidence_ref
          return false unless @observed_at == other.observed_at
          return false unless @last_checked_at == other.last_checked_at
          return false unless @enrichment == other.enrichment
          true
        end
      end
    end
  end
end
