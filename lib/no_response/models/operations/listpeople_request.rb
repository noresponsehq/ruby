# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListPeopleRequest
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

        field :group_id, ::String, {'path_param': {'field_name': "group_id", 'style': "simple", 'explode': false}}
        # Read people after this one.
        field(
          :after,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "after", 'style': "form", 'explode': true}}
        )
        # Only people whose highest finding has this band; none for people with no finding.
        field(
          :band,
          Crystalline::Nilable.new(Models::Shared::ListPeopleBand),
          {'query_param': {'field_name': "band", 'style': "form", 'explode': true}}
        )
        # Only people with this decision; undecided for none yet.
        field(
          :decision,
          Crystalline::Nilable.new(Models::Shared::ListPeopleDecision),
          {'query_param': {'field_name': "decision", 'style': "form", 'explode': true}}
        )
        # Only people with this role; unstated for people whose role was not given.
        field(
          :role,
          Crystalline::Nilable.new(Models::Shared::ListPeopleRole),
          {'query_param': {'field_name': "role", 'style': "form", 'explode': true}}
        )
        # At most this many people.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig {
          params(
            workspace_id: ::String,
            environment: Models::Shared::KeyEnvironment,
            group_id: ::String,
            after: T.nilable(::String),
            band: T.nilable(Models::Shared::ListPeopleBand),
            decision: T.nilable(Models::Shared::ListPeopleDecision),
            role: T.nilable(Models::Shared::ListPeopleRole),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          workspace_id:,
          environment:,
          group_id:,
          after: nil,
          band: nil,
          decision: nil,
          role: nil,
          limit: 100
        )
          @workspace_id = workspace_id
          @environment = environment
          @group_id = group_id
          @after = after
          @band = band
          @decision = decision
          @role = role
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @group_id == other.group_id
          return false unless @after == other.after
          return false unless @band == other.band
          return false unless @decision == other.decision
          return false unless @role == other.role
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
