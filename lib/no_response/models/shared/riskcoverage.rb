# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Counts of planned source-identifier pairs by evidence outcome, deduplicated across signals and incomplete entries. These counts do not measure identity agreement or prove that processing is still running. A lane that was not searched is not an answered source.
      class RiskCoverage
        extend T::Sig
        include Crystalline::MetadataFields

        # Source-identifier pairs that gave a definite found or not_found answer.
        field(
          :answered,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("answered"), required: true}}
        )
        # Source-identifier pairs that could not answer, including unsupported coverage markers and source failures. Read detailed signals to distinguish Not covered from Failed.
        field(
          :failed,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("failed"), required: true}}
        )
        # Source-identifier pairs with deferred or timed_out evidence. A terminal timeout can remain here after processing finishes; use assessment status and continuation metadata to determine whether work is still running.
        field(
          :pending,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("pending"), required: true}}
        )

        sig { params(answered: ::Integer, failed: ::Integer, pending: ::Integer).void }
        def initialize(answered:, failed:, pending:)
          @answered = answered
          @failed = failed
          @pending = pending
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @answered == other.answered
          return false unless @failed == other.failed
          return false unless @pending == other.pending
          true
        end
      end
    end
  end
end
