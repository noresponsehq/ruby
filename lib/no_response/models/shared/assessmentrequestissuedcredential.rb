# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Optional. When your platform issues an API key to the new account, send SHA-256 of that key, so later usage of the key, or a leaked copy, ties back to this assessment. Each SDK has a helper that computes it. Send only the hash: customer keys are high-entropy, so the hash reveals nothing about them. The assessment stores it, and no response, webhook or log carries it.
      class AssessmentRequestIssuedCredential
        extend T::Sig
        include Crystalline::MetadataFields

        # SHA-256 of the issued key's UTF-8 bytes, as 64 lower-case hex characters.
        field(
          :sha256,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sha256"), required: true}}
        )

        sig { params(sha256: ::String).void }
        def initialize(sha256:)
          @sha256 = sha256
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @sha256 == other.sha256
          true
        end
      end
    end
  end
end
