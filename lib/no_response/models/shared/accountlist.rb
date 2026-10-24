# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Body of the 200 answer to GET /v1/accounts: the calling workspace's accounts whose risk changed after changed_since, in the environment of the calling key, oldest change first. An account is listed when its risk_version advanced and it has a current risk, and each item is the account exactly as GET /v1/accounts/{account_id} answers it. An account appears once per page, at its latest change; when its risk changes again later, it appears again on a later page with the newer risk_version. next_cursor is always present: pass it back as changed_since to read the changes made after this page.
      class AccountList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::Account),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )
        # Opaque cursor after the last change this page read, bound to the workspace and the environment of the calling key. Pass it back unchanged as changed_since. It is present on every page, the last one included: when nothing changed after changed_since it is the cursor that was sent, so a poller keeps calling with the latest next_cursor. A tampered or foreign cursor answers 400 invalid_cursor. Consumers do not parse it.
        field(
          :next_cursor,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_cursor"), required: true}}
        )

        sig { params(items: T::Array[Models::Shared::Account], next_cursor: ::String).void }
        def initialize(items:, next_cursor:)
          @items = items
          @next_cursor = next_cursor
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @items == other.items
          return false unless @next_cursor == other.next_cursor
          true
        end
      end
    end
  end
end
