# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # An assessment link also requires assessment_id and assessment_version; an issued_credential link also requires credential_id. Every reference must belong to account_id in this environment. Other kinds reject those fields.
      class ReviewSubjectRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :kind,
          Models::Shared::ReviewSubjectKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ReviewSubjectKind, false)
            }
          }
        )

        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )

        field(
          :reason,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reason"), required: true}}
        )

        field(
          :expected_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expected_version"), required: true}}
        )

        field(
          :assessment_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_id")}}
        )

        field(
          :assessment_version,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessment_version")}}
        )

        field(
          :credential_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("credential_id")}}
        )

        sig {
          params(
            kind: Models::Shared::ReviewSubjectKind,
            account_id: ::String,
            reason: ::String,
            expected_version: ::Integer,
            assessment_id: T.nilable(::String),
            assessment_version: T.nilable(::Integer),
            credential_id: T.nilable(::String)
          )
            .void
        }
        def initialize(
          kind:,
          account_id:,
          reason:,
          expected_version:,
          assessment_id: nil,
          assessment_version: nil,
          credential_id: nil
        )
          @kind = kind
          @account_id = account_id
          @reason = reason
          @expected_version = expected_version
          @assessment_id = assessment_id
          @assessment_version = assessment_version
          @credential_id = credential_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @kind == other.kind
          return false unless @account_id == other.account_id
          return false unless @reason == other.reason
          return false unless @expected_version == other.expected_version
          return false unless @assessment_id == other.assessment_id
          return false unless @assessment_version == other.assessment_version
          return false unless @credential_id == other.credential_id
          true
        end
      end
    end
  end
end
