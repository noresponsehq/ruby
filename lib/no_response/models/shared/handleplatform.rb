# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # HandlePlatform - A platform a screening can cover. github and scratch through flickr are each one read of the public profile a handle names, with no posts. synthetic is the deterministic connector's own platform, for exercising the product end to end with no network.
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
          GITHUB = new("github")
          SCRATCH = new("scratch")
          DAILYMOTION = new("dailymotion")
          SUBSTACK = new("substack")
          DUOLINGO = new("duolingo")
          DOCKERHUB = new("dockerhub")
          WIKIPEDIA = new("wikipedia")
          INTERNETARCHIVE = new("internetarchive")
          SPOTIFY = new("spotify")
          PATREON = new("patreon")
          WORDPRESS = new("wordpress")
          OKRU = new("okru")
          FLICKR = new("flickr")
          SYNTHETIC = new("synthetic")
        end

        open!
      end
    end
  end
end
