# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ListEntryKind - email matches one address, whatever the case of its local part. email_domain matches every address of the registrable domain and of its subdomains.
      class ListEntryKind
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          EMAIL_DOMAIN = new("email_domain")
        end

        open!
      end
    end
  end
end
