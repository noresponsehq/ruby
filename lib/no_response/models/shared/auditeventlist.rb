# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # GET /v1/workspaces/{workspace_id}/audit_events: one page of the workspace's audit log, both environments, newest first. Events are kept for as long as the workspace exists and are deleted with it. next_cursor is present only when another page exists.
      class AuditEventList
        extend T::Sig
        include Crystalline::MetadataFields

        # The workspace id, which is also its live environment's workspace id; the test environment's is the same id with :test appended. A workspace created through the API is tnt_ and a 26-character ULID.
        field(
          :workspace_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("workspace_id"), required: true}}
        )

        field(
          :items,
          Crystalline::Array.new(Models::Shared::AuditEvent),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )
        # Opaque cursor for the next page, MAC'd by the server and bound to the workspace it was issued for. Pass it back unchanged as cursor; a tampered, foreign or expired cursor answers 400 invalid_cursor.
        field(
          :next_cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_cursor")}}
        )

        sig {
          params(workspace_id: ::String, items: T::Array[Models::Shared::AuditEvent], next_cursor: T.nilable(::String))
            .void
        }
        def initialize(workspace_id:, items:, next_cursor: nil)
          @workspace_id = workspace_id
          @items = items
          @next_cursor = next_cursor
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @items == other.items
          return false unless @next_cursor == other.next_cursor
          true
        end
      end
    end
  end
end
