# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Request an asynchronous customer export.
      class CustomerExport
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :kind,
          Models::Shared::CustomerExportRequestKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::CustomerExportRequestKind, false)
            }
          }
        )

        field(
          :environment,
          Models::Shared::Environment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Environment, false)
            }
          }
        )
        # standard returns the consolidated risk response; detailed adds merged provider-neutral facts when the key has detailed scope. There is no raw mode.
        field(
          :response_mode,
          Models::Shared::ResponseMode,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("response_mode"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ResponseMode, false)
            }
          }
        )

        field(
          :status,
          Models::Shared::CustomerExportStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::CustomerExportStatus, false)
            }
          }
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )

        field(
          :records,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("records"), required: true}}
        )

        field(
          :bytes,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("bytes"), required: true}}
        )

        field(
          :chunks,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("chunks"), required: true}}
        )

        field(
          :attempts,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("attempts"), required: true}}
        )

        field(
          :generation,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("generation"), required: true}}
        )

        field(
          :request_sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("request_sha256"), required: true}}
        )

        field(
          :snapshot_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("snapshot_at")}}
        )

        field(
          :finished_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("finished_at")}}
        )

        field(
          :error_code,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("error_code")}}
        )

        sig {
          params(
            id: ::String,
            kind: Models::Shared::CustomerExportRequestKind,
            environment: Models::Shared::Environment,
            response_mode: Models::Shared::ResponseMode,
            status: Models::Shared::CustomerExportStatus,
            created_at: ::String,
            expires_at: ::String,
            records: ::Integer,
            bytes: ::Integer,
            chunks: ::Integer,
            attempts: ::Integer,
            generation: ::Integer,
            request_sha256: ::String,
            snapshot_at: T.nilable(::String),
            finished_at: T.nilable(::String),
            error_code: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          kind:,
          environment:,
          response_mode:,
          status:,
          created_at:,
          expires_at:,
          records:,
          bytes:,
          chunks:,
          attempts:,
          generation:,
          request_sha256:,
          snapshot_at: nil,
          finished_at: nil,
          error_code: nil
        )
          @id = id
          @kind = kind
          @environment = environment
          @response_mode = response_mode
          @status = status
          @created_at = created_at
          @expires_at = expires_at
          @records = records
          @bytes = bytes
          @chunks = chunks
          @attempts = attempts
          @generation = generation
          @request_sha256 = request_sha256
          @snapshot_at = snapshot_at
          @finished_at = finished_at
          @error_code = error_code
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @kind == other.kind
          return false unless @environment == other.environment
          return false unless @response_mode == other.response_mode
          return false unless @status == other.status
          return false unless @created_at == other.created_at
          return false unless @expires_at == other.expires_at
          return false unless @records == other.records
          return false unless @bytes == other.bytes
          return false unless @chunks == other.chunks
          return false unless @attempts == other.attempts
          return false unless @generation == other.generation
          return false unless @request_sha256 == other.request_sha256
          return false unless @snapshot_at == other.snapshot_at
          return false unless @finished_at == other.finished_at
          return false unless @error_code == other.error_code
          true
        end
      end
    end
  end
end
