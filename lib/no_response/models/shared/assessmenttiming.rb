# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AssessmentTiming
        extend T::Sig
        include Crystalline::MetadataFields

        # The budget the server applied to the synchronous answer.
        field(
          :deadline_ms,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("deadline_ms"), required: true}}
        )
        # Server time from HTTP ingress to this revision of the assessment.
        field(
          :elapsed_ms,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("elapsed_ms"), required: true}}
        )

        sig { params(deadline_ms: ::Integer, elapsed_ms: ::Integer).void }
        def initialize(deadline_ms:, elapsed_ms:)
          @deadline_ms = deadline_ms
          @elapsed_ms = elapsed_ms
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @deadline_ms == other.deadline_ms
          return false unless @elapsed_ms == other.elapsed_ms
          true
        end
      end
    end
  end
end
