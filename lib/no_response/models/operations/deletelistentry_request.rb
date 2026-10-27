# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class DeleteListEntryRequest
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
        # The entry's id. An entry of another environment or workspace answers 404.
        field(
          :list_entry_id,
          ::String,
          {'path_param': {'field_name': "list_entry_id", 'style': "simple", 'explode': false}}
        )

        sig {
          params(workspace_id: ::String, environment: Models::Shared::KeyEnvironment, list_entry_id: ::String).void
        }
        def initialize(workspace_id:, environment:, list_entry_id:)
          @workspace_id = workspace_id
          @environment = environment
          @list_entry_id = list_entry_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @list_entry_id == other.list_entry_id
          true
        end
      end
    end
  end
end
