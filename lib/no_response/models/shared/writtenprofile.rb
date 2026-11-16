# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class WrittenProfile
        extend T::Sig
        include Crystalline::MetadataFields

        # queued: the profile is being written. written: summary, statements and leads hold it. failed: it could not be written; error_code says why and no content is returned.
        field(
          :status,
          Models::Shared::WrittenProfileStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::WrittenProfileStatus, false)
            }
          }
        )
        # The investigation whose evidence the profile is written from.
        field(
          :investigation_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("investigation_id"), required: true}}
        )

        field(
          :queued_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("queued_at"), required: true}}
        )
        # Each fact or inference with its certainty and the evidence it cites. Statements that cited evidence the writer was not sent are dropped before storage.
        field(
          :statements,
          Crystalline::Array.new(Models::Shared::ProfileStatement),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("statements"), required: true}}
        )
        # Values worth searching next, each held by a linked record.
        field(
          :leads,
          Crystalline::Array.new(Models::Shared::ProfileLead),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("leads"), required: true}}
        )
        # Present only when status is failed. no_writer: no profile writer serves this environment. refused: the model refused. not_written: the answer was not a profile, or no statement survived grounding. uncited_statement: a statement or lead cited a record the person does not hold. not_answered: the writer did not answer. worker_attempts_exhausted: the worker stopped retrying.
        field(
          :error_code,
          Crystalline::Nilable.new(Models::Shared::WrittenProfileErrorCode),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("error_code"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::WrittenProfileErrorCode, true)
            }
          }
        )

        field(
          :finished_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("finished_at"), required: true}}
        )
        # Present when written: a few plain sentences with the most useful picture first.
        field(
          :summary,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("summary")}}
        )

        sig {
          params(
            status: Models::Shared::WrittenProfileStatus,
            investigation_id: ::String,
            queued_at: ::String,
            statements: T::Array[Models::Shared::ProfileStatement],
            leads: T::Array[Models::Shared::ProfileLead],
            error_code: T.nilable(Models::Shared::WrittenProfileErrorCode),
            finished_at: T.nilable(::String),
            summary: T.nilable(::String)
          )
            .void
        }
        def initialize(
          status:,
          investigation_id:,
          queued_at:,
          statements:,
          leads:,
          error_code: nil,
          finished_at: nil,
          summary: nil
        )
          @status = status
          @investigation_id = investigation_id
          @queued_at = queued_at
          @statements = statements
          @leads = leads
          @error_code = error_code
          @finished_at = finished_at
          @summary = summary
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @status == other.status
          return false unless @investigation_id == other.investigation_id
          return false unless @queued_at == other.queued_at
          return false unless @statements == other.statements
          return false unless @leads == other.leads
          return false unless @error_code == other.error_code
          return false unless @finished_at == other.finished_at
          return false unless @summary == other.summary
          true
        end
      end
    end
  end
end
