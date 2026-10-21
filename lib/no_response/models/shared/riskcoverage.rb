# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Sources counted by state, not named.
      class RiskCoverage
        extend T::Sig
        include Crystalline::MetadataFields

        # Sources that gave a definite answer.
        field(
          :answered,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("answered"), required: true}}
        )
        # Sources that could not answer.
        field(
          :failed,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("failed"), required: true}}
        )
        # Sources still being asked.
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
