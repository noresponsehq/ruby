# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # IpSummaryType - The address's network type.
      class IpSummaryType
        include ::Crystalline::Enum
        enums do
          RESIDENTIAL = new("residential")
          HOSTING = new("hosting")
          VPN = new("vpn")
          PROXY = new("proxy")
          TOR = new("tor")
          MOBILE = new("mobile")
          UNKNOWN = new("unknown")
        end

        open!
      end
    end
  end
end
