# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Where a record came from.
      class RecordSource
        extend T::Sig
        include Crystalline::MetadataFields

        # The id of the connector that read the record.
        field(
          :connector,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("connector"), required: true}}
        )
        # The kind of source: platform for an account read off a live platform.
        field :kind, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("kind"), required: true}}
        # The host a person knows the source's site by.
        field(
          :site,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("site")}}
        )
        # The table a leaked row came from.
        field(
          :table,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("table")}}
        )
        # When the source's data dates from, at the precision it is known.
        field(
          :date,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("date")}}
        )

        sig {
          params(
            connector: ::String,
            kind: ::String,
            site: T.nilable(::String),
            table: T.nilable(::String),
            date: T.nilable(::String)
          )
            .void
        }
        def initialize(connector:, kind:, site: nil, table: nil, date: nil)
          @connector = connector
          @kind = kind
          @site = site
          @table = table
          @date = date
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @connector == other.connector
          return false unless @kind == other.kind
          return false unless @site == other.site
          return false unless @table == other.table
          return false unless @date == other.date
          true
        end
      end
    end
  end
end
