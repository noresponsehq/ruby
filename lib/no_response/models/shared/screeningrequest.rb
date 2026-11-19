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
        # The platforms to search. Leave it out for a full search: every platform a connector serves in the environment when the screening starts, which the screening then lists.
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
