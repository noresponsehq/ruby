# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/webhooks/{endpoint_id}/deliveries/{event_id}/replay body: an empty object.
      class WebhookReplayRequest
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
