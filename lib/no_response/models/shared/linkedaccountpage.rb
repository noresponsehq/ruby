# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Other accounts in this workspace and environment whose retained assessments submitted an email, phone or customer-namespace username that one of account_id's retained assessments also submitted. Matching uses the identifier search rules: exact, canonical and, for email, mailbox. Only customer-submitted identifiers link accounts; source-discovered identifiers do not. Expired, retention-shortened, deleted and erased assessments link nothing. A shared identifier is not verified ownership. Accounts use stable opaque order, the page and total share one database snapshot, and later pages are live. Cursors bind the workspace, environment, operation and account_id, and expire.
      class LinkedAccountPage
        extend T::Sig
        include Crystalline::MetadataFields

        # The account whose submitted identifiers were compared. It is excluded from items.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )

        field(
          :items,
          Crystalline::Array.new(Models::Shared::LinkedAccount),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )
        # Distinct linked accounts, exact below 10000 and capped at 10000.
        field(
          :total,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("total"), required: true}}
        )
        # True when at least 10000 accounts are linked.
        field(
          :total_capped,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("total_capped"), required: true}}
        )
        # Version of the body shape.
        field(
          :schema_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schema_version"), required: true}}
        )
        # Opaque, expiring cursor bound to this environment, operation and account_id. Absent on the last page.
        field(
          :next_cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_cursor")}}
        )

        sig {
          params(
            account_id: ::String,
            items: T::Array[Models::Shared::LinkedAccount],
            total: ::Integer,
            total_capped: T::Boolean,
            schema_version: ::String,
            next_cursor: T.nilable(::String)
          )
            .void
        }
        def initialize(account_id:, items:, total:, total_capped:, schema_version: "1", next_cursor: nil)
          @account_id = account_id
          @items = items
          @total = total
          @total_capped = total_capped
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
          @next_cursor = next_cursor
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @items == other.items
          return false unless @total == other.total
          return false unless @total_capped == other.total_capped
          return false unless @schema_version == other.schema_version
          return false unless @next_cursor == other.next_cursor
          true
        end
      end
    end
  end
end
