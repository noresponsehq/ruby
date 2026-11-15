# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # SourceId - A NoResponse source: github (GitHub accounts), phone (the phone lookup), breach (breach exposure), rdap (the email domain's registration), mx (the email domain's mail servers), ipintel (IP intelligence) or an email account source that searches one platform for an account by email address (adobe, nvidia, wix, life360, zapier, google, duolingo_email). google runs only for Gmail addresses. scratch, dailymotion, substack, duolingo, dockerhub, wikipedia, internetarchive, telegram, spotify, patreon, wordpress, okru and flickr each search that platform for an account by username; telegram also searches by phone number, through a logged-in Telegram lookup account. whatsapp searches WhatsApp for an account by phone number.
      class SourceId
        include ::Crystalline::Enum
        enums do
          GITHUB = new("github")
          PHONE = new("phone")
          BREACH = new("breach")
          RDAP = new("rdap")
          MX = new("mx")
          IPINTEL = new("ipintel")
          ADOBE = new("adobe")
          NVIDIA = new("nvidia")
          WIX = new("wix")
          LIFE360 = new("life360")
          ZAPIER = new("zapier")
          GOOGLE = new("google")
          SCRATCH = new("scratch")
          DAILYMOTION = new("dailymotion")
          SUBSTACK = new("substack")
          DUOLINGO = new("duolingo")
          DUOLINGO_EMAIL = new("duolingo_email")
          DOCKERHUB = new("dockerhub")
          WIKIPEDIA = new("wikipedia")
          INTERNETARCHIVE = new("internetarchive")
          TELEGRAM = new("telegram")
          SPOTIFY = new("spotify")
          PATREON = new("patreon")
          WORDPRESS = new("wordpress")
          OKRU = new("okru")
          FLICKR = new("flickr")
          WHATSAPP = new("whatsapp")
        end

        open!
      end
    end
  end
end
