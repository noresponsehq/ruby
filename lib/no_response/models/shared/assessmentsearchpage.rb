# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A bounded page of latest assessment revisions, newest creation first. Each revision identifies the exact result found; no current account risk is attached.
      class AssessmentSearchPage
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::AssessmentRevision),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
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
            items: T::Array[Models::Shared::AssessmentRevision],
            schema_version: ::String,
            next_cursor: T.nilable(::String),
            retention_days: T.nilable(::Integer)
          )
            .void
        }
        def initialize(items:, schema_version: "1", next_cursor: nil, retention_days: 365)
          @items = items
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
          return false unless @schema_version == other.schema_version
          return false unless @next_cursor == other.next_cursor
          return false unless @retention_days == other.retention_days
          true
        end
      end
    end
  end
end
