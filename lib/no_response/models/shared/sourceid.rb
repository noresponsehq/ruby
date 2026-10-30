# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # SourceId - A NoResponse source: github (GitHub accounts), phone (the phone lookup), breach (breach exposure), rdap (the email domain's registration), mx (the email domain's mail servers), ipintel (IP intelligence) or an email account source that searches one platform for an account by email address (adobe, nvidia, wix, life360, zapier, google). google runs only for Gmail addresses.
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
        end

        open!
      end
    end
  end
end
