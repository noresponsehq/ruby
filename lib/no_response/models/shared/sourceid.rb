# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # SourceId - A NoResponse source: github (GitHub accounts), phone (the phone lookup), breach (breach exposure), rdap (the email domain's registration), mx (the email domain's mail servers), ipintel (IP intelligence) or an email account source that searches one platform for an account by email address (adobe, nvidia, wix, life360, zapier, x_email, snapchat_email, amazon, spotify_email, google, duolingo_email). x_email, snapchat_email, amazon and spotify_email only say whether the email has an account on X, Snapchat, Amazon or Spotify. google runs only for Gmail addresses. scratch, dailymotion, substack, duolingo, dockerhub, wikipedia, internetarchive, telegram, spotify, patreon, wordpress, okru, flickr and chesscom each search that platform for an account by username; telegram also searches by phone number, through a logged-in Telegram lookup account. whatsapp searches WhatsApp for an account by phone number, and life360_phone searches Life360 for one. opplysningen (1881, Norway), ratsit (Sweden) and reverseaustralia (Australia) each look up a phone number of their own country on that site. youtube searches YouTube for a channel by username.
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
          LIFE360_PHONE = new("life360_phone")
          ZAPIER = new("zapier")
          X_EMAIL = new("x_email")
          SNAPCHAT_EMAIL = new("snapchat_email")
          AMAZON = new("amazon")
          SPOTIFY_EMAIL = new("spotify_email")
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
          YOUTUBE = new("youtube")
          SPOTIFY = new("spotify")
          PATREON = new("patreon")
          WORDPRESS = new("wordpress")
          OKRU = new("okru")
          FLICKR = new("flickr")
          CHESSCOM = new("chesscom")
          WHATSAPP = new("whatsapp")
          OPPLYSNINGEN = new("opplysningen")
          RATSIT = new("ratsit")
          REVERSEAUSTRALIA = new("reverseaustralia")
        end

        open!
      end
    end
  end
end
