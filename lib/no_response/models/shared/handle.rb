# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # An account the person is known to hold.
      class Handle
        extend T::Sig
        include Crystalline::MetadataFields

        # A platform a screening can cover. github and scratch through flickr are each one read of the public profile a handle names, with no posts; chesscom also reads the profile's stats, clubs and last two months of games, for its activity and contacts, and through a signed-in session up to 100 of the player's friends, each a contact with the date the friendship began. synthetic is the deterministic connector's own platform, for exercising the product end to end with no network.
        field(
          :platform,
          Models::Shared::HandlePlatform,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("platform"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::HandlePlatform, false)
            }
          }
        )
        # The account's handle, without a leading @.
        field(
          :handle,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("handle"), required: true}}
        )

        sig { params(platform: Models::Shared::HandlePlatform, handle: ::String).void }
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
