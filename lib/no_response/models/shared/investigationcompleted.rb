# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class InvestigationCompleted
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :investigation_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("investigation_id"), required: true}}
        )

        field(
          :person_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person_id"), required: true}}
        )

        field(
          :status,
          Models::Shared::InvestigationCompletedStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::InvestigationCompletedStatus, false)
            }
          }
        )

        field(
          :finished_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("finished_at"), required: true}}
        )

        field(
          :error_code,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("error_code")}}
        )

        sig {
          params(
            investigation_id: ::String,
            person_id: ::String,
            status: Models::Shared::InvestigationCompletedStatus,
            finished_at: ::String,
            error_code: T.nilable(::String)
          )
            .void
        }
        def initialize(investigation_id:, person_id:, status:, finished_at:, error_code: nil)
          @investigation_id = investigation_id
          @person_id = person_id
          @status = status
          @finished_at = finished_at
          @error_code = error_code
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @investigation_id == other.investigation_id
          return false unless @person_id == other.person_id
          return false unless @status == other.status
          return false unless @finished_at == other.finished_at
          return false unless @error_code == other.error_code
          true
        end
      end
    end
  end
end
