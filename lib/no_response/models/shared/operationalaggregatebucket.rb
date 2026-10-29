# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class OperationalAggregateBucket
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :start,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("start"), required: true}}
        )

        field(
          :attempts,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attempts"), required: true}}
        )

        field(
          :succeeded,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("succeeded"), required: true}}
        )

        field(
          :failed,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("failed"), required: true}}
        )

        field(
          :client_errors,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("client_errors"), required: true}}
        )

        field(
          :server_errors,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("server_errors"), required: true}}
        )

        field(
          :replays,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("replays"), required: true}}
        )

        field(
          :incomplete_writes,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("incomplete_writes"), required: true}}
        )

        field(
          :unattributed_keys,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unattributed_keys"), required: true}}
        )
        # Continuous percentile over retained attempts. Omitted when there are no captured samples.
        field(
          :p50_ms,
          Crystalline::Nilable.new(::Float),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("p50_ms")}}
        )
        # Continuous percentile over retained attempts. Omitted when there are no captured samples.
        field(
          :p95_ms,
          Crystalline::Nilable.new(::Float),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("p95_ms")}}
        )
        # Continuous percentile over retained attempts. Omitted when there are no captured samples.
        field(
          :p99_ms,
          Crystalline::Nilable.new(::Float),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("p99_ms")}}
        )

        sig {
          params(
            start: ::String,
            attempts: ::Integer,
            succeeded: ::Integer,
            failed: ::Integer,
            client_errors: ::Integer,
            server_errors: ::Integer,
            replays: ::Integer,
            incomplete_writes: ::Integer,
            unattributed_keys: ::Integer,
            p50_ms: T.nilable(::Float),
            p95_ms: T.nilable(::Float),
            p99_ms: T.nilable(::Float)
          )
            .void
        }
        def initialize(
          start:,
          attempts:,
          succeeded:,
          failed:,
          client_errors:,
          server_errors:,
          replays:,
          incomplete_writes:,
          unattributed_keys:,
          p50_ms: nil,
          p95_ms: nil,
          p99_ms: nil
        )
          @start = start
          @attempts = attempts
          @succeeded = succeeded
          @failed = failed
          @client_errors = client_errors
          @server_errors = server_errors
          @replays = replays
          @incomplete_writes = incomplete_writes
          @unattributed_keys = unattributed_keys
          @p50_ms = p50_ms
          @p95_ms = p95_ms
          @p99_ms = p99_ms
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @start == other.start
          return false unless @attempts == other.attempts
          return false unless @succeeded == other.succeeded
          return false unless @failed == other.failed
          return false unless @client_errors == other.client_errors
          return false unless @server_errors == other.server_errors
          return false unless @replays == other.replays
          return false unless @incomplete_writes == other.incomplete_writes
          return false unless @unattributed_keys == other.unattributed_keys
          return false unless @p50_ms == other.p50_ms
          return false unless @p95_ms == other.p95_ms
          return false unless @p99_ms == other.p99_ms
          true
        end
      end
    end
  end
end
