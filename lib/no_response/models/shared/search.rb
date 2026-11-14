# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One search a person started on a value of one of a person's records. Nothing searches again by itself.
      class Search
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :search_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("search_id"), required: true}}
        )
        # The record whose value led to the search.
        field(
          :record_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("record_id"), required: true}}
        )
        # The field of that record that holds the value.
        field(
          :field,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("field"), required: true}}
        )
        # The kind of the value searched.
        field(
          :kind,
          Models::Shared::SearchKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::SearchKind, false)
            }
          }
        )
        # The value searched: the field's cleaned value, else as the source wrote it.
        field(
          :value,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("value"), required: true}}
        )
        # A password or hash search is counting, then counted: rows says how many breach rows hold the value, and nothing runs until a person runs it (POST .../searches/{search_id}/run). Any other search is queued, then running. completed: every source it asked answered. partial: some did not. failed: none answered or none could be asked, which says nothing about whether the value is held anywhere.
        field(
          :status,
          Models::Shared::SearchStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::SearchStatus, false)
            }
          }
        )
        # How many sources the search asked: the breach search and the account and phone lookups that take the value's kind.
        field(
          :sources,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("sources"), required: true}}
        )
        # How many of them gave a definite answer, found or not found.
        field(
          :answered,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("answered"), required: true}}
        )
        # How many records the search found. They are among the person report's lookup records, each match naming this search.
        field(
          :found,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("found"), required: true}}
        )
        # What the search may spend, in US cents, held against the environment's daily screening cap while it runs.
        field(
          :estimated_spend,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("estimated_spend"), required: true}}
        )
        # What the search spent, in US cents, metered as screening work.
        field(
          :spent,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("spent"), required: true}}
        )
        # Who started the search.
        field(
          :requested_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("requested_by"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )
        # The one breach table searched, when the search was of one table.
        field(
          :table,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("table")}}
        )
        # How many breach rows hold the password or hash, counted before the search runs.
        field(
          :rows,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("rows")}}
        )
        # Why a failed search found nothing: its sources did not answer, none could be asked, or it could not run before its attempts were spent.
        field(
          :error_code,
          Crystalline::Nilable.new(Models::Shared::ErrorCode),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("error_code"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ErrorCode, true)
            }
          }
        )

        field(
          :finished_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("finished_at")}}
        )

        sig {
          params(
            search_id: ::String,
            record_id: ::String,
            field: ::String,
            kind: Models::Shared::SearchKind,
            value: ::String,
            status: Models::Shared::SearchStatus,
            sources: ::Integer,
            answered: ::Integer,
            found: ::Integer,
            estimated_spend: ::Integer,
            spent: ::Integer,
            requested_by: ::String,
            created_at: ::String,
            table: T.nilable(::String),
            rows: T.nilable(::Integer),
            error_code: T.nilable(Models::Shared::ErrorCode),
            finished_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          search_id:,
          record_id:,
          field:,
          kind:,
          value:,
          status:,
          sources:,
          answered:,
          found:,
          estimated_spend:,
          spent:,
          requested_by:,
          created_at:,
          table: nil,
          rows: nil,
          error_code: nil,
          finished_at: nil
        )
          @search_id = search_id
          @record_id = record_id
          @field = field
          @kind = kind
          @value = value
          @status = status
          @sources = sources
          @answered = answered
          @found = found
          @estimated_spend = estimated_spend
          @spent = spent
          @requested_by = requested_by
          @created_at = created_at
          @table = table
          @rows = rows
          @error_code = error_code
          @finished_at = finished_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @search_id == other.search_id
          return false unless @record_id == other.record_id
          return false unless @field == other.field
          return false unless @kind == other.kind
          return false unless @value == other.value
          return false unless @status == other.status
          return false unless @sources == other.sources
          return false unless @answered == other.answered
          return false unless @found == other.found
          return false unless @estimated_spend == other.estimated_spend
          return false unless @spent == other.spent
          return false unless @requested_by == other.requested_by
          return false unless @created_at == other.created_at
          return false unless @table == other.table
          return false unless @rows == other.rows
          return false unless @error_code == other.error_code
          return false unless @finished_at == other.finished_at
          true
        end
      end
    end
  end
end
