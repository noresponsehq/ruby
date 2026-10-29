# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A tenant-local investigation link. risk_version is the account risk version captured when the link was added. It does not assert a relationship or change feedback or enforcement.
      class ReviewSubject
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

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
          :risk_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("risk_version"), required: true}}
        )

        field(
          :reason,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reason"), required: true}}
        )

        field(
          :created_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_by"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
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
            id: ::String,
            kind: Models::Shared::ReviewSubjectKind,
            account_id: ::String,
            risk_version: ::Integer,
            reason: ::String,
            created_by: ::String,
            created_at: ::String,
            assessment_id: T.nilable(::String),
            assessment_version: T.nilable(::Integer),
            credential_id: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          kind:,
          account_id:,
          risk_version:,
          reason:,
          created_by:,
          created_at:,
          assessment_id: nil,
          assessment_version: nil,
          credential_id: nil
        )
          @id = id
          @kind = kind
          @account_id = account_id
          @risk_version = risk_version
          @reason = reason
          @created_by = created_by
          @created_at = created_at
          @assessment_id = assessment_id
          @assessment_version = assessment_version
          @credential_id = credential_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @kind == other.kind
          return false unless @account_id == other.account_id
          return false unless @risk_version == other.risk_version
          return false unless @reason == other.reason
          return false unless @created_by == other.created_by
          return false unless @created_at == other.created_at
          return false unless @assessment_id == other.assessment_id
          return false unless @assessment_version == other.assessment_version
          return false unless @credential_id == other.credential_id
          true
        end
      end
    end
  end
end
