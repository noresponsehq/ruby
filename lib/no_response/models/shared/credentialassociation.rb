# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # An association between an account and an issued key. The response excludes the key and its hash. Retirement removes this association from risk calculations; revoke the actual key through your own service.
      class CredentialAssociation
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # Your own opaque identifier for the account being checked, scoped to your workspace. Use an id you mint, with no direct identifier (email, phone, name or national id) in it. '|' is accepted so an Auth0 user id such as 'auth0|64abc' passes unchanged; '@', '+', '$' and whitespace are refused by the pattern, as is an exact-shape JWT; a hex digest such as a SHA-256 is allowed, because hashing an internal id is a common pseudonymous scheme. A value such as '07700900123' or 'jane.doe.gmail.com' cannot be told apart from an opaque id. It travels in bodies, and in a URL only as the path segment of GET /v1/accounts/{account_id} and its /assessments. An assessment requested by a provider hook at pre_registration, which has no account yet, carries the server-issued account_id pre: followed by its assessment_id.
        field(
          :account_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("account_id"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :actor,
          Models::Shared::CredentialAssociationActor,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("actor"), required: true}}
        )

        field(
          :retired_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retired_at")}}
        )

        field(
          :retired_by,
          Crystalline::Nilable.new(Models::Shared::CredentialAssociationRetiredBy),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retired_by")}}
        )

        sig {
          params(
            id: ::String,
            account_id: ::String,
            created_at: ::String,
            actor: Models::Shared::CredentialAssociationActor,
            retired_at: T.nilable(::String),
            retired_by: T.nilable(Models::Shared::CredentialAssociationRetiredBy)
          )
            .void
        }
        def initialize(id:, account_id:, created_at:, actor:, retired_at: nil, retired_by: nil)
          @id = id
          @account_id = account_id
          @created_at = created_at
          @actor = actor
          @retired_at = retired_at
          @retired_by = retired_by
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @account_id == other.account_id
          return false unless @created_at == other.created_at
          return false unless @actor == other.actor
          return false unless @retired_at == other.retired_at
          return false unless @retired_by == other.retired_by
          true
        end
      end
    end
  end
end
