# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class PersonIdentity
        extend T::Sig
        include Crystalline::MetadataFields

        # Your reference for this person within the workspace environment. Only an explicit reference or person_id can reuse an existing person.
        field(
          :external_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_id")}}
        )
        # The person's full name.
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

        field(
          :handles,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Handle)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("handles")}}
        )

        field(
          :person_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("person_id")}}
        )
        # The person's role in the group: guest (a ticket holder), crew, vendor or press. Leave it out when you do not know it: a person without one has no role, not guest. A later row naming the same person replaces it, and a change of role alone keeps the person's screening results.
        field(
          :role,
          Crystalline::Nilable.new(Models::Shared::PersonRole),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("role"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::PersonRole, true)
            }
          }
        )

        sig {
          params(
            external_id: T.nilable(::String),
            name: T.nilable(::String),
            email: T.nilable(::String),
            phone: T.nilable(::String),
            company: T.nilable(::String),
            city: T.nilable(::String),
            handles: T.nilable(T::Array[Models::Shared::Handle]),
            person_id: T.nilable(::String),
            role: T.nilable(Models::Shared::PersonRole)
          )
            .void
        }
        def initialize(
          external_id: nil,
          name: nil,
          email: nil,
          phone: nil,
          company: nil,
          city: nil,
          handles: nil,
          person_id: nil,
          role: nil
        )
          @external_id = external_id
          @name = name
          @email = email
          @phone = phone
          @company = company
          @city = city
          @handles = handles
          @person_id = person_id
          @role = role
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @external_id == other.external_id
          return false unless @name == other.name
          return false unless @email == other.email
          return false unless @phone == other.phone
          return false unless @company == other.company
          return false unless @city == other.city
          return false unless @handles == other.handles
          return false unless @person_id == other.person_id
          return false unless @role == other.role
          true
        end
      end
    end
  end
end
