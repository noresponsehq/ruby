# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PolicyHistoryItem
        extend T::Sig
        include Crystalline::MetadataFields

        # One environment's settings: how long its assessments are kept, and for each flow the risk thresholds that decide it and the depth a request that names none is served at, and the sources it refuses. Live and test each have their own. A flow without thresholds of its own uses account_creation's (inherits_account_creation). Every change is recorded in the audit log as settings.updated, with who made it.
        field(
          :settings,
          Models::Shared::Settings,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("settings"), required: true}}
        )
        # Capture time, not a backfilled activation time. Absent only for the current configuration before its first capture.
        field(
          :recorded_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("recorded_at")}}
        )

        field(
          :change_reason,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("change_reason")}}
        )

        field(
          :restored_from,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("restored_from")}}
        )
        # Immutable publication provenance remains in policy history after evaluation evidence expires. SHA-256 values identify the frozen manifest, evaluator semantic input, cohort, and canonical result separately.
        field(
          :evaluation,
          Crystalline::Nilable.new(Models::Shared::Publication),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("evaluation")}}
        )

        sig {
          params(
            settings: Models::Shared::Settings,
            recorded_at: T.nilable(::String),
            change_reason: T.nilable(::String),
            restored_from: T.nilable(::Integer),
            evaluation: T.nilable(Models::Shared::Publication)
          )
            .void
        }
        def initialize(settings:, recorded_at: nil, change_reason: nil, restored_from: nil, evaluation: nil)
          @settings = settings
          @recorded_at = recorded_at
          @change_reason = change_reason
          @restored_from = restored_from
          @evaluation = evaluation
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @settings == other.settings
          return false unless @recorded_at == other.recorded_at
          return false unless @change_reason == other.change_reason
          return false unless @restored_from == other.restored_from
          return false unless @evaluation == other.evaluation
          true
        end
      end
    end
  end
end
