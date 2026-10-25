# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class RevokeKeyRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.
        field(
          :workspace_id,
          ::String,
          {'path_param': {'field_name': "workspace_id", 'style': "simple", 'explode': false}}
        )
        # The key's id. A key of another workspace answers 404, as does a key of the other environment to an API key.
        field :key_id, ::String, {'path_param': {'field_name': "key_id", 'style': "simple", 'explode': false}}

        sig { params(workspace_id: ::String, key_id: ::String).void }
        def initialize(workspace_id:, key_id:)
          @workspace_id = workspace_id
          @key_id = key_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @key_id == other.key_id
          true
        end
      end
    end
  end
end
