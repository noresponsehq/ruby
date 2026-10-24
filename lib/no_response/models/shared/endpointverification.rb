# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class EndpointVerification
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque id of the endpoint registration being verified.
        field(
          :endpoint_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("endpoint_id"), required: true}}
        )
        # Endpoint verification nonce: 32 random bytes, unpadded base64url (43 characters). Fresh per verification.
        field(
          :challenge,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("challenge"), required: true}}
        )

        sig { params(endpoint_id: ::String, challenge: ::String).void }
        def initialize(endpoint_id:, challenge:)
          @endpoint_id = endpoint_id
          @challenge = challenge
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @endpoint_id == other.endpoint_id
          return false unless @challenge == other.challenge
          true
        end
      end
    end
  end
end
