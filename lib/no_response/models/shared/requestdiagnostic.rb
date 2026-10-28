# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One authenticated HTTP attempt. An attempt id is independent of the caller correlation id. No raw body, path parameter, credential or source payload is retained. write_complete means the server wrote/flushed its response, not proof the client processed it. Collection is bounded best effort; ii_signup_request_diagnostic_failures_total exposes gaps. Retained for seven days or the shorter environment retention.
      class RequestDiagnostic
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :request_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("request_id"), required: true}}
        )

        field(
          :route,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("route"), required: true}}
        )

        field(
          :http_status,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("http_status"), required: true}}
        )

        field(
          :duration_ms,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("duration_ms"), required: true}}
        )

        field(
          :started_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("started_at"), required: true}}
        )

        field(
          :completed_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("completed_at"), required: true}}
        )

        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )

        field(
          :idempotent_replayed,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("idempotent_replayed"), required: true}}
        )

        field(
          :write_complete,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("write_complete"), required: true}}
        )

        field(
          :error_code,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("error_code")}}
        )
        # The decision prepared for one HTTP attempt. Its account field preserves the account decision returned for that attempt, even after subsequent changes.
        field(
          :decision,
          Crystalline::Nilable.new(Models::Shared::DecisionReceipt),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("decision")}}
        )

        sig {
          params(
            id: ::String,
            request_id: ::String,
            route: ::String,
            http_status: ::Integer,
            duration_ms: ::Integer,
            started_at: ::String,
            completed_at: ::String,
            expires_at: ::String,
            idempotent_replayed: T::Boolean,
            write_complete: T::Boolean,
            error_code: T.nilable(::String),
            decision: T.nilable(Models::Shared::DecisionReceipt)
          )
            .void
        }
        def initialize(
          id:,
          request_id:,
          route:,
          http_status:,
          duration_ms:,
          started_at:,
          completed_at:,
          expires_at:,
          idempotent_replayed:,
          write_complete:,
          error_code: nil,
          decision: nil
        )
          @id = id
          @request_id = request_id
          @route = route
          @http_status = http_status
          @duration_ms = duration_ms
          @started_at = started_at
          @completed_at = completed_at
          @expires_at = expires_at
          @idempotent_replayed = idempotent_replayed
          @write_complete = write_complete
          @error_code = error_code
          @decision = decision
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @request_id == other.request_id
          return false unless @route == other.route
          return false unless @http_status == other.http_status
          return false unless @duration_ms == other.duration_ms
          return false unless @started_at == other.started_at
          return false unless @completed_at == other.completed_at
          return false unless @expires_at == other.expires_at
          return false unless @idempotent_replayed == other.idempotent_replayed
          return false unless @write_complete == other.write_complete
          return false unless @error_code == other.error_code
          return false unless @decision == other.decision
          true
        end
      end
    end
  end
end
