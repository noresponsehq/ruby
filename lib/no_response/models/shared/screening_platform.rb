# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ScreeningPlatform
        include ::Crystalline::Enum
        enums do
          INSTAGRAM = new("instagram")
          X = new("x")
          BLUESKY = new("bluesky")
          YOUTUBE = new("youtube")
          TIKTOK = new("tiktok")
          FACEBOOK = new("facebook")
          THREADS = new("threads")
          REDDIT = new("reddit")
          TELEGRAM = new("telegram")
          LINKEDIN = new("linkedin")
        end

        open!
      end
    end
  end
end
