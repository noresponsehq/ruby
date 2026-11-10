# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # How many items read were not analysed for one reason.
      class ScreeningNotAnalysedCount
        extend T::Sig
        include Crystalline::MetadataFields

        # Why an item read was not analysed. video: a video, whose caption alone is read. image_unavailable: the image could not be fetched from the platform. image_unsupported: not a JPEG, PNG, GIF or WebP image, or too large to send. image_limit: past the most images one attendee's analysis reads. refused: the model declined to read it. unfinished: the model cut its batch short or answered outside the schema, or the request was rejected. unverified: a finding cited it with words it does not contain or an image it did not describe. unspecified: the analyser gave no reason.
        field(
          :reason,
          Models::Shared::ScreeningNotAnalysedReason,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("reason"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ScreeningNotAnalysedReason, false)
            }
          }
        )

        field(
          :items,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig { params(reason: Models::Shared::ScreeningNotAnalysedReason, items: ::Integer).void }
        def initialize(reason:, items:)
          @reason = reason
          @items = items
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @reason == other.reason
          return false unless @items == other.items
          true
        end
      end
    end
  end
end
