# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/keys/rotate body. The tenant and the key being rotated are the API key that signs the request, so neither is a body member. An empty object takes the default overlap.
      class KeyRotationRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # How long the presented key keeps working beside the new one, from 60 seconds to 7 days. Default 86400 (24 hours). At the end of the overlap the presented key stops authenticating.
        field(
          :overlap_seconds,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("overlap_seconds")}}
        )

        sig { params(overlap_seconds: T.nilable(::Integer)).void }
        def initialize(overlap_seconds: nil)
          @overlap_seconds = overlap_seconds
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @overlap_seconds == other.overlap_seconds
          true
        end
      end
    end
  end
end
