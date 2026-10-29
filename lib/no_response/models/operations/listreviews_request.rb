# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListReviewsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.
        field(
          :workspace_id,
          ::String,
          {'path_param': {'field_name': "workspace_id", 'style': "simple", 'explode': false}}
        )
        # The environment: live or test. Each has its own settings. Any other value answers 400. An API key reads and changes only its own environment's; the other answers 404.
        field(
          :environment,
          Models::Shared::KeyEnvironment,
          {'path_param': {'field_name': "environment", 'style': "simple", 'explode': false}}
        )

        field(
          :cursor,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "cursor", 'style': "form", 'explode': true}}
        )

        field(
          :status,
          Crystalline::Nilable.new(Models::Shared::ReviewStatus),
          {'query_param': {'field_name': "status", 'style': "form", 'explode': true}}
        )

        field(
          :priority,
          Crystalline::Nilable.new(Models::Shared::Priority),
          {'query_param': {'field_name': "priority", 'style': "form", 'explode': true}}
        )

        field(
          :assignee,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "assignee", 'style': "form", 'explode': true}}
        )

        field(
          :unassigned,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'query_param': {'field_name': "unassigned", 'style': "form", 'explode': true}}
        )
        # Filter by immutable member ID. Mutually exclusive with assignee and unassigned=true.
        field(
          :assignee_principal_id,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "assignee_principal_id", 'style': "form", 'explode': true}}
        )
        # Only reviews of this exact account in the authenticated workspace and environment. Applied before pagination and bound into the cursor.
        field(
          :account_id,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "account_id", 'style': "form", 'explode': true}}
        )

        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig {
          params(
            workspace_id: ::String,
            environment: Models::Shared::KeyEnvironment,
            cursor: T.nilable(::String),
            status: T.nilable(Models::Shared::ReviewStatus),
            priority: T.nilable(Models::Shared::Priority),
            assignee: T.nilable(::String),
            unassigned: T.nilable(T::Boolean),
            assignee_principal_id: T.nilable(::String),
            account_id: T.nilable(::String),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          workspace_id:,
          environment:,
          cursor: nil,
          status: nil,
          priority: nil,
          assignee: nil,
          unassigned: nil,
          assignee_principal_id: nil,
          account_id: nil,
          limit: 50
        )
          @workspace_id = workspace_id
          @environment = environment
          @cursor = cursor
          @status = status
          @priority = priority
          @assignee = assignee
          @unassigned = unassigned
          @assignee_principal_id = assignee_principal_id
          @account_id = account_id
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @cursor == other.cursor
          return false unless @status == other.status
          return false unless @priority == other.priority
          return false unless @assignee == other.assignee
          return false unless @unassigned == other.unassigned
          return false unless @assignee_principal_id == other.assignee_principal_id
          return false unless @account_id == other.account_id
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
