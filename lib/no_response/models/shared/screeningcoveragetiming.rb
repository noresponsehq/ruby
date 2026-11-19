# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # How long this search's latest attempt took, stage by stage. started_at minus the investigation's creation is the time spent queued or retrying.
      class ScreeningCoverageTiming
        extend T::Sig
        include Crystalline::MetadataFields

        # When the attempt that wrote this result started.
        field(
          :started_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("started_at"), required: true}}
        )
        # Milliseconds from started_at to the end of the last stage listed.
        field(
          :total_ms,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("total_ms"), required: true}}
        )
        # Stages finished so far, in order. The result first written lists stages up to written; the settled result lists them all.
        field(
          :stages,
          Crystalline::Array.new(Models::Shared::StageTime),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("stages"), required: true}}
        )

        sig { params(started_at: ::String, total_ms: ::Integer, stages: T::Array[Models::Shared::StageTime]).void }
        def initialize(started_at:, total_ms:, stages:)
          @started_at = started_at
          @total_ms = total_ms
          @stages = stages
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @started_at == other.started_at
          return false unless @total_ms == other.total_ms
          return false unless @stages == other.stages
          true
        end
      end
    end
  end
end
