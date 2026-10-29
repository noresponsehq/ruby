# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Current retained delivery queue, independent of the requested attempt window and status filter. Endpoint filter applies. Does not prove customer enforcement execution.
      class OperationalAggregateQueue
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :pending,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("pending"), required: true}}
        )

        field(
          :leased,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("leased"), required: true}}
        )

        field(
          :dead_retained,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("dead_retained"), required: true}}
        )

        field(
          :oldest_pending_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("oldest_pending_at")}}
        )

        sig {
          params(
            pending: ::Integer,
            leased: ::Integer,
            dead_retained: ::Integer,
            oldest_pending_at: T.nilable(::String)
          )
            .void
        }
        def initialize(pending:, leased:, dead_retained:, oldest_pending_at: nil)
          @pending = pending
          @leased = leased
          @dead_retained = dead_retained
          @oldest_pending_at = oldest_pending_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @pending == other.pending
          return false unless @leased == other.leased
          return false unless @dead_retained == other.dead_retained
          return false unless @oldest_pending_at == other.oldest_pending_at
          true
        end
      end
    end
  end
end
