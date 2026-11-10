# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ScreeningNotAnalysedReason - Why an item read was not analysed. video: a video, whose caption alone is read. image_unavailable: the image could not be fetched from the platform. image_unsupported: not a JPEG, PNG, GIF or WebP image, or too large to send. image_limit: past the most images one attendee's analysis reads. refused: the model declined to read it. unfinished: the model cut its batch short or answered outside the schema, or the request was rejected. unverified: a finding cited it with words it does not contain or an image it did not describe. unspecified: the analyser gave no reason.
      class ScreeningNotAnalysedReason
        include ::Crystalline::Enum
        enums do
          VIDEO = new("video")
          IMAGE_UNAVAILABLE = new("image_unavailable")
          IMAGE_UNSUPPORTED = new("image_unsupported")
          IMAGE_LIMIT = new("image_limit")
          REFUSED = new("refused")
          UNFINISHED = new("unfinished")
          UNVERIFIED = new("unverified")
          UNSPECIFIED = new("unspecified")
        end

        open!
      end
    end
  end
end
