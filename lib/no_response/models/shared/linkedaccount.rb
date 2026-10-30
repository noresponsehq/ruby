# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class LinkedAccount
        extend T::Sig
        include Crystalline::MetadataFields

        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id}, its /assessments and its /linked_accounts. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )
        # One entry per shared kind, in the order email, phone, username. Each entry uses the strictest basis that links the two accounts: exact, then canonical, then mailbox.
        field(
          :shared_identifiers,
          Crystalline::Array.new(Models::Shared::SharedIdentifier),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("shared_identifiers"), required: true}}
        )

        sig { params(account_id: ::String, shared_identifiers: T::Array[Models::Shared::SharedIdentifier]).void }
        def initialize(account_id:, shared_identifiers:)
          @account_id = account_id
          @shared_identifiers = shared_identifiers
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @shared_identifiers == other.shared_identifiers
          true
        end
      end
    end
  end
end
