# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListAttendeesRequest
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

        field :event_id, ::String, {'path_param': {'field_name': "event_id", 'style': "simple", 'explode': false}}
        # Read attendees after this one.
        field(
          :after,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "after", 'style': "form", 'explode': true}}
        )
        # Only attendees whose highest finding has this band; none for attendees with no finding.
        field(
          :band,
          Crystalline::Nilable.new(Models::Shared::ListAttendeesBand),
          {'query_param': {'field_name': "band", 'style': "form", 'explode': true}}
        )
        # Only attendees with this decision; undecided for none yet.
        field(
          :decision,
          Crystalline::Nilable.new(Models::Shared::ListAttendeesDecision),
          {'query_param': {'field_name': "decision", 'style': "form", 'explode': true}}
        )
        # At most this many attendees.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig {
          params(
            workspace_id: ::String,
            environment: Models::Shared::KeyEnvironment,
            event_id: ::String,
            after: T.nilable(::String),
            band: T.nilable(Models::Shared::ListAttendeesBand),
            decision: T.nilable(Models::Shared::ListAttendeesDecision),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(workspace_id:, environment:, event_id:, after: nil, band: nil, decision: nil, limit: 100)
          @workspace_id = workspace_id
          @environment = environment
          @event_id = event_id
          @after = after
          @band = band
          @decision = decision
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @event_id == other.event_id
          return false unless @after == other.after
          return false unless @band == other.band
          return false unless @decision == other.decision
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
