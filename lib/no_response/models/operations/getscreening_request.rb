# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class GetScreeningRequest
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

        field(
          :screening_id,
          ::String,
          {'path_param': {'field_name': "screening_id", 'style': "simple", 'explode': false}}
        )

        sig {
          params(
            workspace_id: ::String,
            environment: Models::Shared::KeyEnvironment,
            group_id: ::String,
            screening_id: ::String
          )
            .void
        }
        def initialize(workspace_id:, environment:, group_id:, screening_id:)
          @workspace_id = workspace_id
          @environment = environment
          @group_id = group_id
          @screening_id = screening_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @group_id == other.group_id
          return false unless @screening_id == other.screening_id
          true
        end
      end
    end
  end
end
