# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListPolicyHistoryRequest
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
          :before_version,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "before_version", 'style': "form", 'explode': true}}
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
            before_version: T.nilable(::Integer),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(workspace_id:, environment:, before_version: nil, limit: 50)
          @workspace_id = workspace_id
          @environment = environment
          @before_version = before_version
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @before_version == other.before_version
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
