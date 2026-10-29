# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Review
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
          :status,
          Models::Shared::ReviewStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ReviewStatus, false)
            }
          }
        )

        field(
          :priority,
          Models::Shared::Priority,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("priority"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Priority, false)
            }
          }
        )

        field(
          :version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("version"), required: true}}
        )

        field(
          :opened_risk_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("opened_risk_version"), required: true}}
        )

        field(
          :current_risk_version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("current_risk_version"), required: true}}
        )

        field(
          :created_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_by"), required: true}}
        )

        field(
          :updated_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_by"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :updated_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("updated_at"), required: true}}
        )

        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )

        field(
          :assignee,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assignee")}}
        )

        field(
          :resolution,
          Crystalline::Nilable.new(Models::Shared::Resolution),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("resolution")}}
        )
        # Immutable workspace member ID. assignee is the historical display identity captured at assignment.
        field(
          :assignee_principal_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("assignee_principal_id")}}
        )

        sig {
          params(
            id: ::String,
            account_id: ::String,
            status: Models::Shared::ReviewStatus,
            priority: Models::Shared::Priority,
            version: ::Integer,
            opened_risk_version: ::Integer,
            current_risk_version: ::Integer,
            created_by: ::String,
            updated_by: ::String,
            created_at: ::String,
            updated_at: ::String,
            expires_at: ::String,
            assignee: T.nilable(::String),
            resolution: T.nilable(Models::Shared::Resolution),
            assignee_principal_id: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          account_id:,
          status:,
          priority:,
          version:,
          opened_risk_version:,
          current_risk_version:,
          created_by:,
          updated_by:,
          created_at:,
          updated_at:,
          expires_at:,
          assignee: nil,
          resolution: nil,
          assignee_principal_id: nil
        )
          @id = id
          @account_id = account_id
          @status = status
          @priority = priority
          @version = version
          @opened_risk_version = opened_risk_version
          @current_risk_version = current_risk_version
          @created_by = created_by
          @updated_by = updated_by
          @created_at = created_at
          @updated_at = updated_at
          @expires_at = expires_at
          @assignee = assignee
          @resolution = resolution
          @assignee_principal_id = assignee_principal_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @account_id == other.account_id
          return false unless @status == other.status
          return false unless @priority == other.priority
          return false unless @version == other.version
          return false unless @opened_risk_version == other.opened_risk_version
          return false unless @current_risk_version == other.current_risk_version
          return false unless @created_by == other.created_by
          return false unless @updated_by == other.updated_by
          return false unless @created_at == other.created_at
          return false unless @updated_at == other.updated_at
          return false unless @expires_at == other.expires_at
          return false unless @assignee == other.assignee
          return false unless @resolution == other.resolution
          return false unless @assignee_principal_id == other.assignee_principal_id
          true
        end
      end
    end
  end
end
