# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A pending workspace invitation. Creating or reissuing it returns a token once; lists omit it. The token can be accepted once before expiry and is invalidated on revocation or reissue. Token state does not establish email delivery.
      class Invite
        extend T::Sig
        include Crystalline::MetadataFields

        # Opaque, server-assigned invite id: inv_ and a 26-character ULID.
        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}
        # The workspace id, which is also its live environment's workspace id; the test environment's is the same id with :test appended. A workspace created through the API is tnt_ and a 26-character ULID.
        field(
          :workspace_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("workspace_id"), required: true}}
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
        # The stable member id that issued this invite, or the authenticated live API key prefix for members_manage automation. Reissuing preserves the original creator; the audit event names the reissuing actor.
        field(
          :created_by,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_by"), required: true}}
        )

        field(
          :created_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("created_at"), required: true}}
        )

        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )
        # Where the console sends the invite. Informational: it is not matched against the accepting user.
        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # The user's id at the identity provider the console signs people in with: 1 to 256 printable ASCII characters with no space, compared exactly.
        field(
          :external_user_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_user_id")}}
        )
        # The invite token: nrinv_, the invite id's ULID, _ and 43 unpadded base64url characters (32 random bytes). The new member's console sends it to POST /v1/invites/accept.
        field(
          :token,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("token")}}
        )
        # Allowed data environments. Invites default to both. Omitted on member PATCH preserves the current grants; owners retain both.
        field(
          :environments,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::InviteEnvironment)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("environments")}}
        )
        # Independent removals from a built-in preset: sensitive evidence, exports, or active policy publication. Owners retain full authority. Omitted member updates preserve exclusions.
        field(
          :denied_actions,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::InviteDeniedAction)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("denied_actions")}}
        )
        # Last token reissue, not proof of email delivery.
        field(
          :reissued_at,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reissued_at")}}
        )

        sig {
          params(
            id: ::String,
            workspace_id: ::String,
            role: Models::Shared::Role,
            created_by: ::String,
            created_at: ::String,
            expires_at: ::String,
            email: T.nilable(::String),
            external_user_id: T.nilable(::String),
            token: T.nilable(::String),
            environments: T.nilable(T::Array[Models::Shared::InviteEnvironment]),
            denied_actions: T.nilable(T::Array[Models::Shared::InviteDeniedAction]),
            reissued_at: T.nilable(::String)
          )
            .void
        }
        def initialize(
          id:,
          workspace_id:,
          role:,
          created_by:,
          created_at:,
          expires_at:,
          email: nil,
          external_user_id: nil,
          token: nil,
          environments: nil,
          denied_actions: nil,
          reissued_at: nil
        )
          @id = id
          @workspace_id = workspace_id
          @role = role
          @created_by = created_by
          @created_at = created_at
          @expires_at = expires_at
          @email = email
          @external_user_id = external_user_id
          @token = token
          @environments = environments
          @denied_actions = denied_actions
          @reissued_at = reissued_at
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @workspace_id == other.workspace_id
          return false unless @role == other.role
          return false unless @created_by == other.created_by
          return false unless @created_at == other.created_at
          return false unless @expires_at == other.expires_at
          return false unless @email == other.email
          return false unless @external_user_id == other.external_user_id
          return false unless @token == other.token
          return false unless @environments == other.environments
          return false unless @denied_actions == other.denied_actions
          return false unless @reissued_at == other.reissued_at
          true
        end
      end
    end
  end
end
