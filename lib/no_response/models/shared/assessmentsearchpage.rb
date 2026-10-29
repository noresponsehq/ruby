# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A bounded page of latest assessment revisions, newest creation first, with how many assessments match the filters. Each item is the revision found and its first answer's decision; no current account risk is attached.
      class AssessmentSearchPage
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::AssessmentSearchItem),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )
        # How many assessments match the filters over every page, counted when this page was read: exact up to 10000. At 10000 or more it is 10000 and total_capped is true. The cursor does not change it; a later page can count differently, as results are live.
        field(
          :total,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("total"), required: true}}
        )
        # True when at least 10000 assessments match, so total is 10000 and not the exact count.
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
        # The calling workspace's configured retention period in days. Default 365 (12 months), which is also the maximum: a workspace may only shorten it, to at least 1 day. Each record expires from its own created_at; see assessment expires_at.
        field(
          :retention_days,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retention_days")}}
        )

        sig {
          params(
            items: T::Array[Models::Shared::AssessmentSearchItem],
            total: ::Integer,
            total_capped: T::Boolean,
            schema_version: ::String,
            next_cursor: T.nilable(::String),
            retention_days: T.nilable(::Integer)
          )
            .void
        }
        def initialize(items:, total:, total_capped:, schema_version: "1", next_cursor: nil, retention_days: 365)
          @items = items
          @total = total
          @total_capped = total_capped
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
          @next_cursor = next_cursor
          @retention_days = retention_days
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @items == other.items
          return false unless @total == other.total
          return false unless @total_capped == other.total_capped
          return false unless @schema_version == other.schema_version
          return false unless @next_cursor == other.next_cursor
          return false unless @retention_days == other.retention_days
          true
        end
      end
    end
  end
end
