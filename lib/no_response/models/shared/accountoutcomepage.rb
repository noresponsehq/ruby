# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # List retained account reports, newest first. The page-level effective outcome id names the current report. Each receipt preserves the effective report and risk version from its original write. Page with the returned cursor.
      class AccountOutcomePage
        extend T::Sig
        include Crystalline::MetadataFields

        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id} and its /assessments. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )

        field(
          :items,
          Crystalline::Array.new(Models::Shared::AccountOutcome),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )
        # Opaque, expiring cursor bound to this environment, operation and every filter. Keep the filters unchanged.
        field(
          :next_cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("next_cursor")}}
        )
        # Opaque, server-assigned id of one recorded outcome: 'out_' and a 26-character Crockford base32 ULID. Unique within the workspace.
        field(
          :effective_outcome_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("effective_outcome_id")}}
        )

        sig {
          params(
            account_id: ::String,
            items: T::Array[Models::Shared::AccountOutcome],
            next_cursor: T.nilable(::String),
            effective_outcome_id: T.nilable(::String)
          )
            .void
        }
        def initialize(account_id:, items:, next_cursor: nil, effective_outcome_id: nil)
          @account_id = account_id
          @items = items
          @next_cursor = next_cursor
          @effective_outcome_id = effective_outcome_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @items == other.items
          return false unless @next_cursor == other.next_cursor
          return false unless @effective_outcome_id == other.effective_outcome_id
          true
        end
      end
    end
  end
end
