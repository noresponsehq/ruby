# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One evidence lane that did not settle, and why. It names a lane, not a source. A lane that missed its deadline is timed_out rather than not_found.
      class IncompleteSource
        extend T::Sig
        include Crystalline::MetadataFields

        # An evidence lane: accounts (account presence for email and username), phone, breach and ip.
        field(
          :lane,
          Models::Shared::Lane,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("lane"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Lane, false)
            }
          }
        )
        # Why a lane did not settle. deferred means the lane is asynchronous and still running; a continuation settles it. timed_out means the lane missed its deadline. insufficient_evidence is a settled inconclusive signal rather than an incomplete lane.
        field(
          :reason,
          Models::Shared::IncompleteReason,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("reason"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::IncompleteReason, false)
            }
          }
        )

        sig { params(lane: Models::Shared::Lane, reason: Models::Shared::IncompleteReason).void }
        def initialize(lane:, reason:)
          @lane = lane
          @reason = reason
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @lane == other.lane
          return false unless @reason == other.reason
          true
        end
      end
    end
  end
end
