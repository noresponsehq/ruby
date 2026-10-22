# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/webhooks body. The tenant is the API key that signs the request, so it is not a body member. The URL must be https on port 443 or 8443 with a DNS name, not an IP literal, and every address the name resolves to must be public.
      class WebhookEndpointRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Where deliveries are sent: an https URL on port 443 or 8443, with a DNS host and no userinfo or fragment, at most 2048 characters.
        field :url, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("url"), required: true}}
        # standard returns the consolidated risk response; detailed adds merged provider-neutral facts when the key has detailed scope. There is no raw mode.
        field(
          :response_mode,
          Crystalline::Nilable.new(Models::Shared::ResponseMode),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("response_mode"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ResponseMode, true)
            }
          }
        )

        sig { params(url: ::String, response_mode: T.nilable(Models::Shared::ResponseMode)).void }
        def initialize(url:, response_mode: nil)
          @url = url
          @response_mode = response_mode
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @url == other.url
          return false unless @response_mode == other.response_mode
          true
        end
      end
    end
  end
end
