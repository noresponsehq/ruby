# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One member of a workspace: an external user id holding one role. A removed member loses every permission at once.
      class Member
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned member id: mem_ and a 26-character ULID. It stays the same when a removed member is invited back.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # The workspace id, which is also its live environment's workspace id; the test environment's is the same id with :test appended. A workspace created through the API is tnt_ and a 26-character ULID.
        field(
          :workspace_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("workspace_id"), required: true}}
        )
        # The user's id at the identity provider the console signs people in with: 1 to 256 printable ASCII characters with no space, compared exactly.
        field(
          :external_user_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_user_id"), required: true}}
        )
        # A built-in capability set. Specialist roles are independent; effective access is returned by GET /v1/workspaces/{workspace_id}/capabilities.
        field(
          :role,
          Models::Shared::Role,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("role"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Role, false)
            }
          }
        )
        # Listed and returned members are active.
        field(
          :status,
          Models::Shared::MemberStatus,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::MemberStatus, false)
            }
          }
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
        # Allowed data environments. Invites default to both. Omitted on member PATCH preserves the current grants; owners retain both.
        field(
          :environments,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::MemberEnvironment)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("environments")}}
        )
        # Independent removals from a built-in preset: sensitive evidence, exports, or active policy publication. Owners retain full authority. Omitted member updates preserve exclusions.
        field(
          :denied_actions,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::MemberDeniedAction)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("denied_actions")}}
        )
        # Immutable internal workspace principal, equal to member id, preserved across explicit provider-identity migrations.
        field(
          :principal_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("principal_id")}}
        )
        # Informational display name. Authentication and provider identity use the verified subject binding.
        field(
          :display_name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("display_name")}}
        )
        # Unverified contact address for display. Empty clears it; a supplied value must be an address. Identity linking uses the verified provider subject.
        field(
          :unverified_email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("unverified_email")}}
        )

        sig {
          params(
            id: ::String,
            workspace_id: ::String,
            external_user_id: ::String,
            role: Models::Shared::Role,
            status: Models::Shared::MemberStatus,
            created_at: ::String,
            updated_at: ::String,
            environments: T.nilable(T::Array[Models::Shared::MemberEnvironment]),
            denied_actions: T.nilable(T::Array[Models::Shared::MemberDeniedAction]),
            principal_id: T.nilable(::String),
            display_name: T.nilable(::String),
            unverified_email: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          workspace_id:,
          external_user_id:,
          role:,
          status:,
          created_at:,
          updated_at:,
          environments: nil,
          denied_actions: nil,
          principal_id: nil,
          display_name: nil,
          unverified_email: nil
        )
          @id = id
          @workspace_id = workspace_id
          @external_user_id = external_user_id
          @role = role
          @status = status
          @created_at = created_at
          @updated_at = updated_at
          @environments = environments
          @denied_actions = denied_actions
          @principal_id = principal_id
          @display_name = display_name
          @unverified_email = unverified_email
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @workspace_id == other.workspace_id
          return false unless @external_user_id == other.external_user_id
          return false unless @role == other.role
          return false unless @status == other.status
          return false unless @created_at == other.created_at
          return false unless @updated_at == other.updated_at
          return false unless @environments == other.environments
          return false unless @denied_actions == other.denied_actions
          return false unless @principal_id == other.principal_id
          return false unless @display_name == other.display_name
          return false unless @unverified_email == other.unverified_email
          true
        end
      end
    end
  end
end
