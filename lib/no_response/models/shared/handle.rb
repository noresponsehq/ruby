# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # An account the person is known to hold.
      class Handle
        extend T::Sig
        include Crystalline::MetadataFields

        # A platform a screening can cover, such as instagram, x, bluesky, youtube, tiktok or github. The screening registry owns the set: a request that names a platform it does not cover answers 422. A new platform adds an id without changing this contract, so read a platform you do not know in a response as one you have not seen before, not as an error. synthetic is the deterministic connector's own platform, for exercising the product end to end with no network.
        field(
          :platform,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("platform"), required: true}}
        )
        # The account's handle, without a leading @.
        field(
          :handle,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("handle"), required: true}}
        )

        sig { params(platform: ::String, handle: ::String).void }
        def initialize(platform:, handle:)
          @platform = platform
          @handle = handle
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @platform == other.platform
          return false unless @handle == other.handle
          true
        end
      end
    end
  end
end
