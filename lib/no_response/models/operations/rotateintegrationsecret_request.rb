# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class RotateIntegrationSecretRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Path segment, matched case-sensitively. A value that does not match the integration_id shape, or another workspace's id, answers 404.
        field(
          :integration_id,
          ::String,
          {'path_param': {'field_name': "integration_id", 'style': "simple", 'explode': false}}
        )

        field :body, Models::Shared::IntegrationRotationRequest, {'request': {'media_type': "application/json"}}

        sig { params(integration_id: ::String, body: Models::Shared::IntegrationRotationRequest).void }
        def initialize(integration_id:, body:)
          @integration_id = integration_id
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @integration_id == other.integration_id
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
