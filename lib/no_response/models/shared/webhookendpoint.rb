# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One of the workspace's registered webhook endpoints. Signing secrets are not part of it: a secret is shown once, when it is issued (POST /v1/webhooks and POST /v1/webhooks/{endpoint_id}/rotate).
      class WebhookEndpoint
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque id of the endpoint registration.
        field(
          :endpoint_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint_id"), required: true}}
        )
        # The destination URL, as registered.
        field :url, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("url"), required: true}}
        # unverified until the endpoint echoes an endpoint.verification challenge (send one with POST /v1/webhooks/{endpoint_id}/test); verified receives assessment.updated events; disabled after 72 hours of continuous delivery failure, and verified again by the same challenge.
        field(
          :state,
          Models::Shared::WebhookEndpointState,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("state"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::WebhookEndpointState, false)
            }
          }
        )
        # standard returns the consolidated risk response; detailed adds merged provider-neutral facts when the key has detailed scope. There is no raw mode.
        field(
          :response_mode,
          Models::Shared::ResponseMode,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("response_mode"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ResponseMode, false)
            }
          }
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # The keys a receiver may see in NR-Webhook-Key-Id, oldest first. The last one signs every new delivery; an older one keeps verifying until its expires_at.
        field(
          :signing_keys,
          Crystalline::Array.new(Models::Shared::SigningKey),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("signing_keys"), required: true}}
        )
        # When the endpoint last echoed a challenge. Absent until it first does.
        field(
          :verified_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("verified_at")}}
        )

        sig {
          params(
            endpoint_id: ::String,
            url: ::String,
            state: Models::Shared::WebhookEndpointState,
            response_mode: Models::Shared::ResponseMode,
            created_at: ::String,
            signing_keys: T::Array[Models::Shared::SigningKey],
            verified_at: T.nilable(::String)
          )
            .void
        }
        def initialize(endpoint_id:, url:, state:, response_mode:, created_at:, signing_keys:, verified_at: nil)
          @endpoint_id = endpoint_id
          @url = url
          @state = state
          @response_mode = response_mode
          @created_at = created_at
          @signing_keys = signing_keys
          @verified_at = verified_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint_id == other.endpoint_id
          return false unless @url == other.url
          return false unless @state == other.state
          return false unless @response_mode == other.response_mode
          return false unless @created_at == other.created_at
          return false unless @signing_keys == other.signing_keys
          return false unless @verified_at == other.verified_at
          true
        end
      end
    end
  end
end
