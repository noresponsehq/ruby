# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # HandlePlatform - A platform a screening can cover. synthetic is the deterministic connector's own platform, for exercising the product end to end with no network.
      class HandlePlatform
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
          SYNTHETIC = new("synthetic")
        end

        open!
      end
    end
  end
end
