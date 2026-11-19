# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PersonChange
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # account_added and account_removed: an account or profile appeared or disappeared. breach_added and breach_removed: a breach record appeared or disappeared. identifier_added and identifier_removed: an email, phone, username, name or account id on an account the person already held. field_changed: another field on such an account. posts_added: new posts, counted in count.
        field(
          :kind,
          Models::Shared::PersonChangeKind,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("kind"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::PersonChangeKind, false)
            }
          }
        )
        # One rule ranks every change: identity changes (accounts, breaches, identifiers) are high, profile fields are medium, new posts are low.
        field(
          :significance,
          Models::Shared::Significance,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("significance"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Significance, false)
            }
          }
        )
        # The connector, site or platform the change came from.
        field(
          :source,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("source"), required: true}}
        )
        # The investigation that found the change.
        field(
          :investigation_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("investigation_id"), required: true}}
        )
        # The earlier investigation it was compared with.
        field(
          :previous_investigation_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("previous_investigation_id"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :field,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("field")}}
        )

        field(
          :before,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("before")}}
        )

        field(
          :after,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("after")}}
        )

        field(
          :count,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("count")}}
        )

        field(
          :reviewed_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reviewed_at"), required: true}}
        )

        field(
          :reviewed_by,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reviewed_by")}}
        )

        sig {
          params(
            id: ::String,
            kind: Models::Shared::PersonChangeKind,
            significance: Models::Shared::Significance,
            source: ::String,
            investigation_id: ::String,
            previous_investigation_id: ::String,
            created_at: ::String,
            field: T.nilable(::String),
            before: T.nilable(::String),
            after: T.nilable(::String),
            count: T.nilable(::Integer),
            reviewed_at: T.nilable(::String),
            reviewed_by: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          kind:,
          significance:,
          source:,
          investigation_id:,
          previous_investigation_id:,
          created_at:,
          field: nil,
          before: nil,
          after: nil,
          count: nil,
          reviewed_at: nil,
          reviewed_by: nil
        )
          @id = id
          @kind = kind
          @significance = significance
          @source = source
          @investigation_id = investigation_id
          @previous_investigation_id = previous_investigation_id
          @created_at = created_at
          @field = field
          @before = before
          @after = after
          @count = count
          @reviewed_at = reviewed_at
          @reviewed_by = reviewed_by
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @kind == other.kind
          return false unless @significance == other.significance
          return false unless @source == other.source
          return false unless @investigation_id == other.investigation_id
          return false unless @previous_investigation_id == other.previous_investigation_id
          return false unless @created_at == other.created_at
          return false unless @field == other.field
          return false unless @before == other.before
          return false unless @after == other.after
          return false unless @count == other.count
          return false unless @reviewed_at == other.reviewed_at
          return false unless @reviewed_by == other.reviewed_by
          true
        end
      end
    end
  end
end
