# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class SendWebhookTestEventRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The endpoint's whe_ id. An id that is unknown, malformed or another workspace's answers 404.
        field :endpoint_id, ::String, {'path_param': {'field_name': "endpoint_id", 'style': "simple", 'explode': false}}

        field :body, Models::Shared::WebhookTestRequest, {'request': {'media_type': "application/json"}}

        sig { params(endpoint_id: ::String, body: Models::Shared::WebhookTestRequest).void }
        def initialize(endpoint_id:, body:)
          @endpoint_id = endpoint_id
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint_id == other.endpoint_id
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
