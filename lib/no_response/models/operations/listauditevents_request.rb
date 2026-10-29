# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListAuditEventsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.
        field(
          :workspace_id,
          ::String,
          {'path_param': {'field_name': "workspace_id", 'style': "simple", 'explode': false}}
        )
        # next_cursor from the previous page, unchanged; keep every filter unchanged.
        field(
          :cursor,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "cursor", 'style': "form", 'explode': true}}
        )
        # Affected scope. API keys can request only their own environment. Omit to read the scopes the caller is allowed.
        field(
          :environment,
          Crystalline::Nilable.new(Models::Shared::Environment),
          {'query_param': {'field_name': "environment", 'style': "form", 'explode': true}}
        )
        # Exact action, such as key.created or account.deleted.
        field(
          :action,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "action", 'style': "form", 'explode': true}}
        )
        # Exact external user id, public API key id or console credential id.
        field(
          :actor,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "actor", 'style': "form", 'explode': true}}
        )
        # Exact target kind, such as key, member, setting or workspace.
        field(
          :target_type,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "target_type", 'style': "form", 'explode': true}}
        )
        # Public target identifier. Audit targets exclude subject identifiers.
        field(
          :target_id,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "target_id", 'style': "form", 'explode': true}}
        )
        # Exact outcome.
        field(
          :outcome,
          Crystalline::Nilable.new(Models::Shared::CustomerExportRequestFilterOutcome),
          {'query_param': {'field_name': "outcome", 'style': "form", 'explode': true}}
        )
        # Inclusive creation timestamp in RFC3339 format.
        field(
          :since,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "since", 'style': "form", 'explode': true}}
        )
        # Exclusive creation timestamp in RFC3339 format; must follow since when both are supplied.
        field(
          :until_,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "until", 'style': "form", 'explode': true}}
        )
        # Events per page.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig {
          params(
            workspace_id: ::String,
            cursor: T.nilable(::String),
            environment: T.nilable(Models::Shared::Environment),
            action: T.nilable(::String),
            actor: T.nilable(::String),
            target_type: T.nilable(::String),
            target_id: T.nilable(::String),
            outcome: T.nilable(Models::Shared::CustomerExportRequestFilterOutcome),
            since: T.nilable(::String),
            until_: T.nilable(::String),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          workspace_id:,
          cursor: nil,
          environment: nil,
          action: nil,
          actor: nil,
          target_type: nil,
          target_id: nil,
          outcome: nil,
          since: nil,
          until_: nil,
          limit: 20
        )
          @workspace_id = workspace_id
          @cursor = cursor
          @environment = environment
          @action = action
          @actor = actor
          @target_type = target_type
          @target_id = target_id
          @outcome = outcome
          @since = since
          @until_ = until_
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @cursor == other.cursor
          return false unless @environment == other.environment
          return false unless @action == other.action
          return false unless @actor == other.actor
          return false unless @target_type == other.target_type
          return false unless @target_id == other.target_id
          return false unless @outcome == other.outcome
          return false unless @since == other.since
          return false unless @until_ == other.until_
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
