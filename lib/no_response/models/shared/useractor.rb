# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class UserActor
        extend T::Sig
        include Crystalline::MetadataFields

        # The user's id at the identity provider the console signs people in with: 1 to 256 printable ASCII characters with no space, compared exactly.
        field(
          :external_user_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_user_id"), required: true}}
        )
        # The public id of the console credential the user acted through.
        field(
          :console_credential_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("console_credential_id"), required: true}}
        )

        field :type, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("type"), required: true}}
        # Stable workspace principal id, retained across identity-provider subject migration. Absent for older events.
        field(
          :principal_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("principal_id")}}
        )

        sig {
          params(
            external_user_id: ::String,
            console_credential_id: ::String,
            type: ::String,
            principal_id: T.nilable(::String)
          )
            .void
        }
        def initialize(external_user_id:, console_credential_id:, type: "user", principal_id: nil)
          @external_user_id = external_user_id
          @console_credential_id = console_credential_id
          unless type == "user"
            raise ArgumentError, "Invalid value for type"
          end

          @type = "user"
          @principal_id = principal_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @external_user_id == other.external_user_id
          return false unless @console_credential_id == other.console_credential_id
          return false unless @type == other.type
          return false unless @principal_id == other.principal_id
          true
        end
      end
    end
  end
end
