# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Distinct observed accounts with retained assessments. Typed identifier searches use stable opaque account order, independent of newly submitted assessments; ordinary and legacy email searches use newest-seen order. One repeatable-read database snapshot supplies each page's rows and totals. Pages do not share a snapshot: new matching accounts may appear on a later page or before the cursor and be missed until a fresh search; retention, erasure and changed membership can remove results. Current account decisions are read separately and may advance during a page. Cursors bind the workspace/environment, operation and filters, expire, and cannot cross scopes. Erasure and retention always take precedence over pagination.
      class AccountDirectoryPage
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::AccountDirectoryPageItem),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )
        # Distinct accounts matching the filters, exact below 10000 and capped at 10000.
        field(
          :total,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("total"), required: true}}
        )
        # True when at least 10000 accounts match.
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
        # Opaque, expiring cursor bound to this environment, operation and every filter. Keep the filters unchanged.
        field(
          :next_cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_cursor")}}
        )

        sig {
          params(
            items: T::Array[Models::Shared::AccountDirectoryPageItem],
            total: ::Integer,
            total_capped: T::Boolean,
            schema_version: ::String,
            next_cursor: T.nilable(::String)
          )
            .void
        }
        def initialize(items:, total:, total_capped:, schema_version: "1", next_cursor: nil)
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
