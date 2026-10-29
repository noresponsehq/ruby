# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One privileged workspace action with its actor, target, outcome and time. Successful data changes commit their audit evidence atomically. Sensitive exports record access before returning bytes. Details exclude secrets and subject identifiers.
      class AuditEvent
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned event id: aud_ and a 26-character ULID.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # The workspace id, which is also its live environment's workspace id; the test environment's is the same id with :test appended. A workspace created through the API is tnt_ and a 26-character ULID.
        field(
          :workspace_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("workspace_id"), required: true}}
        )

        field(
          :environment,
          Models::Shared::AuditSettingsEnvironment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AuditSettingsEnvironment, false)
            }
          }
        )
        # What happened, as resource.verb: workspace.created, member.role_changed, member.removed, invite.created, invite.revoked, invite.accepted, key.rotated, webhook_endpoint.created, webhook_endpoint.deleted, webhook_endpoint.secret_rotated, integration.created, integration.deleted, integration.secret_rotated, list_entry.created, list_entry.deleted, webhook_endpoint.test_sent, webhook_endpoint.verification_requested, webhook_endpoint.delivery_replayed, assessment.created, assessment.outcome_recorded, assessment.deleted, account.outcome_recorded, account.enforcement_recorded, account.deleted, account.exported. A change with no finer name carries the permission it used, such as keys.live.write. New actions may appear; treat an unknown one as a change to its target.
        field(
          :action,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("action"), required: true}}
        )

        field(
          :outcome,
          Models::Shared::CustomerExportRequestFilterOutcome,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("outcome"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(
                Models::Shared::CustomerExportRequestFilterOutcome,
                false
              )
            }
          }
        )

        field(
          :actor,
          Crystalline::DiscriminatedUnion.new(
            "type",
            {"user" => Models::Shared::UserActor, "api_key" => Models::Shared::KeyActor}
          ),
          {
            'format_json': {'letter_case': ::NoResponse::Utils.field_name("actor"), required: true},
            'discriminator': "type",
            'discriminator_mapping': {"user" => Models::Shared::UserActor, "api_key" => Models::Shared::KeyActor}
          }
        )

        field(
          :target,
          Models::Shared::AuditEventTarget,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("target"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # At most 8 short facts about the change, keyed by lowercase names: the role a member was given or accepted (role), the invite an accepted member used (invite_id), the key that replaced a rotated one (new_key_id), the assessment a member's change acted on (assessment_id). Absent when there are none.
        field(
          :detail,
          Crystalline::Nilable.new(Crystalline::Hash.new(Symbol, ::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("detail")}}
        )

        field(
          :affected_environment,
          Crystalline::Nilable.new(Models::Shared::Environment),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("affected_environment"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Environment, true)
            }
          }
        )
        # Validated request correlation id, also returned in X-Request-ID, linking this event to request diagnostics. Absent on historical events without correlation.
        field(
          :request_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("request_id")}}
        )

        sig {
          params(
            id: ::String,
            workspace_id: ::String,
            environment: Models::Shared::AuditSettingsEnvironment,
            action: ::String,
            outcome: Models::Shared::CustomerExportRequestFilterOutcome,
            actor: T.any(Models::Shared::UserActor, Models::Shared::KeyActor),
            target: Models::Shared::AuditEventTarget,
            created_at: ::String,
            detail: T.nilable(T::Hash[Symbol, ::String]),
            affected_environment: T.nilable(Models::Shared::Environment),
            request_id: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          workspace_id:,
          environment:,
          action:,
          outcome:,
          actor:,
          target:,
          created_at:,
          detail: nil,
          affected_environment: nil,
          request_id: nil
        )
          @id = id
          @workspace_id = workspace_id
          @environment = environment
          @action = action
          @outcome = outcome
          @actor = actor
          @target = target
          @created_at = created_at
          @detail = detail
          @affected_environment = affected_environment
          @request_id = request_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @action == other.action
          return false unless @outcome == other.outcome
          return false unless @actor == other.actor
          return false unless @target == other.target
          return false unless @created_at == other.created_at
          return false unless @detail == other.detail
          return false unless @affected_environment == other.affected_environment
          return false unless @request_id == other.request_id
          true
        end
      end
    end
  end
end
