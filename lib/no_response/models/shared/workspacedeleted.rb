# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Terminal for the receiving endpoint's environment: its workspace was deleted. Every key of the environment already answers 401, its assessments and accounts are gone, and no further event follows. The workspace id is not reused, so a later event naming it cannot arrive.
      class WorkspaceDeleted
        extend T::Sig
        include Crystalline::MetadataFields

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
        # When the deletion took effect, equal to deleted_at in the DELETE answer.
        field(
          :deleted_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("deleted_at"), required: true}}
        )

        sig {
          params(workspace_id: ::String, environment: Models::Shared::AuditSettingsEnvironment, deleted_at: ::String)
            .void
        }
        def initialize(workspace_id:, environment:, deleted_at:)
          @workspace_id = workspace_id
          @environment = environment
          @deleted_at = deleted_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @deleted_at == other.deleted_at
          true
        end
      end
    end
  end
end
