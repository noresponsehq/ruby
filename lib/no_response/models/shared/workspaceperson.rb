# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class WorkspacePerson
        extend T::Sig
        include Crystalline::MetadataFields

        field :id, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id"), required: true}}

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
        # The time the workspace retention policy removes this person, their evidence and investigation history. Shortening workspace retention can move this time earlier.
        field(
          :expires_at,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("expires_at"), required: true}}
        )
        # Your reference for this person within the workspace environment. Only an explicit reference or person_id can reuse an existing person.
        field(
          :external_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_id")}}
        )

        field(
          :name,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name")}}
        )
        # The person's email.
        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # The person's phone in E.164 form.
        field(
          :phone,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone")}}
        )
        # Where the person works.
        field(
          :company,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("company")}}
        )
        # Where the person lives.
        field(
          :city,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("city")}}
        )
        # A username the person uses, with no platform. A search looks it up on every platform that finds accounts by username.
        field(
          :username,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("username")}}
        )
        # Accounts the person is known to hold, at most 20.
        field(
          :handles,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Handle)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("handles")}}
        )

        sig {
          params(
            id: ::String,
            created_at: ::String,
            updated_at: ::String,
            expires_at: ::String,
            external_id: T.nilable(::String),
            name: T.nilable(::String),
            email: T.nilable(::String),
            phone: T.nilable(::String),
            company: T.nilable(::String),
            city: T.nilable(::String),
            username: T.nilable(::String),
            handles: T.nilable(T::Array[Models::Shared::Handle])
          )
            .void
        }
        def initialize(
          id:,
          created_at:,
          updated_at:,
          expires_at:,
          external_id: nil,
          name: nil,
          email: nil,
          phone: nil,
          company: nil,
          city: nil,
          username: nil,
          handles: nil
        )
          @id = id
          @created_at = created_at
          @updated_at = updated_at
          @expires_at = expires_at
          @external_id = external_id
          @name = name
          @email = email
          @phone = phone
          @company = company
          @city = city
          @username = username
          @handles = handles
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @id == other.id
          return false unless @created_at == other.created_at
          return false unless @updated_at == other.updated_at
          return false unless @expires_at == other.expires_at
          return false unless @external_id == other.external_id
          return false unless @name == other.name
          return false unless @email == other.email
          return false unless @phone == other.phone
          return false unless @company == other.company
          return false unless @city == other.city
          return false unless @username == other.username
          return false unless @handles == other.handles
          true
        end
      end
    end
  end
end
