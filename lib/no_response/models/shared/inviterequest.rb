# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/workspaces/{workspace_id}/invites body. Creates an invite for role and returns its token once. email is where the console sends the token and is not checked against the user who accepts. With external_user_id set, only that user can accept.
      class InviteRequest
        extend T::Sig
        include Crystalline::MetadataFields

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
        # Allowed data environments. Invites default to both. Omitted on member PATCH preserves the current grants; owners retain both.
        field(
          :environments,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::InviteRequestEnvironment)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("environments")}}
        )
        # Independent removals from a built-in preset: sensitive evidence, exports, or active policy publication. Owners retain full authority. Omitted member updates preserve exclusions.
        field(
          :denied_actions,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::InviteRequestDeniedAction)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("denied_actions")}}
        )

        sig {
          params(
            role: Models::Shared::Role,
            email: T.nilable(::String),
            external_user_id: T.nilable(::String),
            environments: T.nilable(T::Array[Models::Shared::InviteRequestEnvironment]),
            denied_actions: T.nilable(T::Array[Models::Shared::InviteRequestDeniedAction])
          )
            .void
        }
        def initialize(role:, email: nil, external_user_id: nil, environments: nil, denied_actions: nil)
          @role = role
          @email = email
          @external_user_id = external_user_id
          @environments = environments
          @denied_actions = denied_actions
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @role == other.role
          return false unless @email == other.email
          return false unless @external_user_id == other.external_user_id
          return false unless @environments == other.environments
          return false unless @denied_actions == other.denied_actions
          true
        end
      end
    end
  end
end
