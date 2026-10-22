# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Body of the 200 answer to POST /v1/assessments/query: one page of the calling tenant's unexpired assessments for one account, newest first, each at its latest assessment_version. Every item's account_id equals the page's. An assessment past its expires_at is not listed. next_cursor is present only when another page exists.
      class AssessmentList
        extend T::Sig
        include Crystalline::MetadataFields

        # Your own opaque identifier for the account being checked, scoped to your tenant. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused, as is a JWT; a hex digest such as a SHA-256 is allowed. It travels only in request bodies. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )

        field(
          :items,
          Crystalline::Array.new(Models::Shared::Assessment),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )
        # Version of the body shape.
        field(
          :schema_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schema_version"), required: true}}
        )
        # Opaque cursor for the next page, bound to your tenant and the account_id it was issued for. Pass it back unchanged in the next query; a tampered, foreign or expired cursor answers 400 invalid_cursor.
        field(
          :next_cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_cursor")}}
        )
        # Your current retention period, so a consumer knows how far back history reaches. Every item expires no later than its created_at plus this many days.
        field(
          :retention_days,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retention_days")}}
        )

        sig {
          params(
            account_id: ::String,
            items: T::Array[Models::Shared::Assessment],
            schema_version: ::String,
            next_cursor: T.nilable(::String),
            retention_days: T.nilable(::Integer)
          )
            .void
        }
        def initialize(account_id:, items:, schema_version: "1", next_cursor: nil, retention_days: 365)
          @account_id = account_id
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
          return false unless @account_id == other.account_id
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
