# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # The body an endpoint returns, with status 200 and Content-Type application/json within 5 seconds, to an endpoint.verification event. A 2xx without the echoed challenge does not verify the endpoint.
      class WebhookVerificationResponse
        extend T::Sig
        include Crystalline::MetadataFields

        # Endpoint verification nonce: 32 random bytes, unpadded base64url (43 characters). Fresh per verification.
        field(
          :challenge,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("challenge"), required: true}}
        )

        sig { params(challenge: ::String).void }
        def initialize(challenge:)
          @challenge = challenge
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @challenge == other.challenge
          true
        end
      end
    end
  end
end
