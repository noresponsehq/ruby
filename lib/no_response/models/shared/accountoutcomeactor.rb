# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class AccountOutcomeActor
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :type,
          Models::Shared::AccountOutcomeActorType,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("type"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AccountOutcomeActorType, false)
            }
          }
        )

        field(
          :key_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("key_id")}}
        )
        # The user's id at the identity provider the console signs people in with: 1 to 256 printable ASCII characters with no space, compared exactly.
        field(
          :external_user_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_user_id")}}
        )

        field(
          :console_credential_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("console_credential_id")}}
        )
        # Opaque, server-assigned member id: mem_ and a 26-character ULID. It stays the same when a removed member is invited back.
        field(
          :principal_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("principal_id")}}
        )

        sig {
          params(
            type: Models::Shared::AccountOutcomeActorType,
            key_id: T.nilable(::String),
            external_user_id: T.nilable(::String),
            console_credential_id: T.nilable(::String),
            principal_id: T.nilable(::String)
          )
            .void
        }
        def initialize(type:, key_id: nil, external_user_id: nil, console_credential_id: nil, principal_id: nil)
          @type = type
          @key_id = key_id
          @external_user_id = external_user_id
          @console_credential_id = console_credential_id
          @principal_id = principal_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @type == other.type
          return false unless @key_id == other.key_id
          return false unless @external_user_id == other.external_user_id
          return false unless @console_credential_id == other.console_credential_id
          return false unless @principal_id == other.principal_id
          true
        end
      end
    end
  end
end
