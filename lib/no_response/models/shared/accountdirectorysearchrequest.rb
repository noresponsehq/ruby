# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Bounded distinct-account search for a single authenticated workspace/environment. Email matches any retained admitted assessment of an account, using assessment search's canonical mailbox rules. No assessment history download is required.
      class AccountDirectorySearchRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id} and its /assessments. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id")}}
        )
        # Assessments of every account that one of its retained admitted assessments sent this mailbox as identifiers.email, matched as lists match an email entry: case-insensitive, a +tag removed and, at gmail.com and googlemail.com, the dots of the local part ignored. Only assessments stored since email list matching began carry the mailbox. An address that is not a valid mailbox is refused with 400.
        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # Opaque, expiring cursor bound to this environment, operation and every filter. Keep the filters unchanged.
        field(
          :cursor,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("cursor")}}
        )
        # Select accounts with a retained open or in-progress review, or a current review/block account decision with no retained effective account outcome. The server applies this filter before counting and pagination. Requires reviews.read as well as history.read for console members; API keys additionally require management.
        field(
          :needs_action,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("needs_action")}}
        )

        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("limit")}}
        )

        sig {
          params(
            account_id: T.nilable(::String),
            email: T.nilable(::String),
            cursor: T.nilable(::String),
            needs_action: T.nilable(T::Boolean),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(account_id: nil, email: nil, cursor: nil, needs_action: false, limit: 25)
          @account_id = account_id
          @email = email
          @cursor = cursor
          @needs_action = needs_action
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @account_id == other.account_id
          return false unless @email == other.email
          return false unless @cursor == other.cursor
          return false unless @needs_action == other.needs_action
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
