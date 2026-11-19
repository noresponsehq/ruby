# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # PersonChangeKind - account_added and account_removed: an account or profile appeared or disappeared. breach_added and breach_removed: a breach record appeared or disappeared. identifier_added and identifier_removed: an email, phone, username, name or account id on an account the person already held. field_changed: another field on such an account. posts_added: new posts, counted in count.
      class PersonChangeKind
        include ::Crystalline::Enum
        enums do
          ACCOUNT_ADDED = new("account_added")
          ACCOUNT_REMOVED = new("account_removed")
          BREACH_ADDED = new("breach_added")
          BREACH_REMOVED = new("breach_removed")
          IDENTIFIER_ADDED = new("identifier_added")
          IDENTIFIER_REMOVED = new("identifier_removed")
          FIELD_CHANGED = new("field_changed")
          POSTS_ADDED = new("posts_added")
        end

        open!
      end
    end
  end
end
