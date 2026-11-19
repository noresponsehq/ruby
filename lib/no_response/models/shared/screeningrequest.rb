# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Screens the group's people no screening has reached.
      class ScreeningRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :depth,
          Models::Shared::ScreeningDepth,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("depth"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ScreeningDepth, false)
            }
          }
        )
        # Deprecated: leave it out. Without it the screening is a full search: every platform a connector serves in the environment when the screening starts, which the screening then lists, each searched only with the identifiers its connector takes. A list sent here still limits the screening until a later contract release removes the field.
        #
        # @deprecated true: This will be removed in a future release, please migrate away from it as soon as possible.
        field(
          :platforms,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("platforms")}}
        )

        sig { params(depth: Models::Shared::ScreeningDepth, platforms: T.nilable(T::Array[::String])).void }
        def initialize(depth:, platforms: nil)
          @depth = depth
          @platforms = platforms
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @depth == other.depth
          return false unless @platforms == other.platforms
          true
        end
      end
    end
  end
end
