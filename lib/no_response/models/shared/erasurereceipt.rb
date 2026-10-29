# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Acknowledged propagation of a retained erasure record in the calling environment. Pending means the target has not acknowledged completion. Completion covers these serving-system targets only; backup and point-in-time recovery copies expire according to their own retention policy. This receipt contains no subject id or digest. Workspace teardown revokes customer credentials, so obtain required receipts before teardown.
      class ErasureReceipt
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-issued erasure receipt id. It contains no subject identifier.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field(
          :kind,
          Models::Shared::ErasureReceiptKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ErasureReceiptKind, false)
            }
          }
        )

        field(
          :status,
          Models::Shared::ListChangeState,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ListChangeState, false)
            }
          }
        )

        field(
          :assessments_deleted,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assessments_deleted"), required: true}}
        )

        field(
          :requested_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("requested_at"), required: true}}
        )

        field(
          :targets,
          Crystalline::Array.new(Models::Shared::ErasureReceiptTarget),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("targets"), required: true}}
        )

        field(
          :backup_policy,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("backup_policy"), required: true}}
        )

        field(
          :completed_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("completed_at")}}
        )

        sig {
          params(
            id: ::String,
            kind: Models::Shared::ErasureReceiptKind,
            status: Models::Shared::ListChangeState,
            assessments_deleted: ::Integer,
            requested_at: ::String,
            targets: T::Array[Models::Shared::ErasureReceiptTarget],
            backup_policy: ::String,
            completed_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          kind:,
          status:,
          assessments_deleted:,
          requested_at:,
          targets:,
          backup_policy:,
          completed_at: nil
        )
          @id = id
          @kind = kind
          @status = status
          @assessments_deleted = assessments_deleted
          @requested_at = requested_at
          @targets = targets
          @backup_policy = backup_policy
          @completed_at = completed_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @kind == other.kind
          return false unless @status == other.status
          return false unless @assessments_deleted == other.assessments_deleted
          return false unless @requested_at == other.requested_at
          return false unless @targets == other.targets
          return false unless @backup_policy == other.backup_policy
          return false unless @completed_at == other.completed_at
          true
        end
      end
    end
  end
end
