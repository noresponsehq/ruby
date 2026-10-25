# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # SourceId - A NoResponse source: github (GitHub accounts), phone (the phone lookup), breach (breach exposure), rdap (the email domain's registration), mx (the email domain's mail servers) or ipintel (IP intelligence).
      class SourceId
        include ::Crystalline::Enum
        enums do
          GITHUB = new("github")
          PHONE = new("phone")
          BREACH = new("breach")
          RDAP = new("rdap")
          MX = new("mx")
          IPINTEL = new("ipintel")
        end

        open!
      end
    end
  end
end
