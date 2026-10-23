# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The 201 answer of POST /v1/webhooks: the new endpoint, unverified, and its first signing secret, shown once. Store the secret where the receiver reads it, then send endpoint.verification with POST /v1/webhooks/{endpoint_id}/test.
      class WebhookEndpointCreated
        extend T::Sig
        include Crystalline::MetadataFields

        # One of the workspace's registered webhook endpoints. Signing secrets are not part of it: a secret is shown once, when it is issued (POST /v1/webhooks and POST /v1/webhooks/{endpoint_id}/rotate).
        field(
          :endpoint,
          Models::Shared::WebhookEndpoint,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint"), required: true}}
        )
        # A newly issued signing key with its secret, shown only in this answer. A receiver verifies NR-Webhook-Signature with the secret's UTF-8 bytes as the HMAC-SHA256 key.
        field(
          :signing_secret,
          Models::Shared::SigningSecret,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("signing_secret"), required: true}}
        )

        sig { params(endpoint: Models::Shared::WebhookEndpoint, signing_secret: Models::Shared::SigningSecret).void }
        def initialize(endpoint:, signing_secret:)
          @endpoint = endpoint
          @signing_secret = signing_secret
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint == other.endpoint
          return false unless @signing_secret == other.signing_secret
          true
        end
      end
    end
  end
end
