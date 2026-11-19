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

        sig { params(depth: Models::Shared::ScreeningDepth).void }
        def initialize(depth:)
          @depth = depth
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @depth == other.depth
          true
        end
      end
    end
  end
end
