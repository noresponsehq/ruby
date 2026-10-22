# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/webhooks/{endpoint_id}/rotate body: an empty object. The old key keeps verifying for 7 days.
      class WebhookKeyRotationRequest
        extend T::Sig
        include Crystalline::MetadataFields

        def initialize
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          true
        end
      end
    end
  end
end
