# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Associate the SHA-256 of a high-entropy key issued by your service. Send the hash instead of the key. Repeating a hash returns its original association, including its retirement state. A hash associated with another account returns a conflict.
      class CredentialRequest
        extend T::Sig
        include Crystalline::MetadataFields

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
