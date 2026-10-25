# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/integrations/{integration_id}/rotate body. For an Auth0 integration send {}: NoResponse generates a new shared secret and returns it once. For a WorkOS or Supabase integration send the new signing_secret after regenerating it in the provider's dashboard. Either way the previous secret is still accepted for 24 hours, so the provider can be switched over without a refused call.
      class IntegrationRotationRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The WorkOS Actions signing secret or the Supabase hook secret, as the provider's dashboard shows it: 16 to 256 printable ASCII characters with no spaces. It is stored sealed and is not returned.
        field(
          :signing_secret,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("signing_secret")}}
        )

        sig { params(signing_secret: T.nilable(::String)).void }
        def initialize(signing_secret: nil)
          @signing_secret = signing_secret
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @signing_secret == other.signing_secret
          true
        end
      end
    end
  end
end
