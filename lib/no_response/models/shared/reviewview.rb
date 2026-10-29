# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ReviewView
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}

        field(
          :owner,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("owner"), required: true}}
        )
        # The credential namespace of the creator. An external user ID equal to an API-key label does not grant ownership of that key's private view.
        field(
          :owner_type,
          Models::Shared::OwnerType,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("owner_type"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::OwnerType, false)
            }
          }
        )

        field(
          :shared,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("shared"), required: true}}
        )

        field(
          :version,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("version"), required: true}}
        )

        field(
          :filter,
          Models::Shared::Filter,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("filter"), required: true}}
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
        # Immutable member ID or API key ID, interpreted with owner_type. Ownership survives changes to an external user identity.
        field(
          :owner_principal_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("owner_principal_id"), required: true}}
        )

        sig {
          params(
            id: ::String,
            name: ::String,
            owner: ::String,
            owner_type: Models::Shared::OwnerType,
            shared: T::Boolean,
            version: ::Integer,
            filter: Models::Shared::Filter,
            created_at: ::String,
            updated_at: ::String,
            owner_principal_id: ::String
          )
            .void
        }
        def initialize(
          id:,
          name:,
          owner:,
          owner_type:,
          shared:,
          version:,
          filter:,
          created_at:,
          updated_at:,
          owner_principal_id:
        )
          @id = id
          @name = name
          @owner = owner
          @owner_type = owner_type
          @shared = shared
          @version = version
          @filter = filter
          @created_at = created_at
          @updated_at = updated_at
          @owner_principal_id = owner_principal_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @name == other.name
          return false unless @owner == other.owner
          return false unless @owner_type == other.owner_type
          return false unless @shared == other.shared
          return false unless @version == other.version
          return false unless @filter == other.filter
          return false unless @created_at == other.created_at
          return false unless @updated_at == other.updated_at
          return false unless @owner_principal_id == other.owner_principal_id
          true
        end
      end
    end
  end
end
