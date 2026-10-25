# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListKeysRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.
        field(
          :workspace_id,
          ::String,
          {'path_param': {'field_name': "workspace_id", 'style': "simple", 'explode': false}}
        )

        sig { params(workspace_id: ::String).void }
        def initialize(workspace_id:)
          @workspace_id = workspace_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          true
        end
      end
    end
  end
end
