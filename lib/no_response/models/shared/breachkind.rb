# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # BreachKind - Who is in the table: site_breach, a site's own users; credential_list, a combolist or compilation; stealer_log, malware or botnet victims; scrape; hacking_forum, a criminal hacking, cracking or carding community; abuse_service, the customers of DDoS-for-hire, account generators, dump or card shops, darknet markets, stalkerware or breach-lookup services; darkweb_site, an onion site of unknown purpose.
      class BreachKind
        include ::Crystalline::Enum
        enums do
          SITE_BREACH = new("site_breach")
          CREDENTIAL_LIST = new("credential_list")
          STEALER_LOG = new("stealer_log")
          SCRAPE = new("scrape")
          HACKING_FORUM = new("hacking_forum")
          ABUSE_SERVICE = new("abuse_service")
          DARKWEB_SITE = new("darkweb_site")
        end

        open!
      end
    end
  end
end
