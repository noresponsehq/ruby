# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # What you know about an attendee. Stored encrypted under the workspace's key.
      class AttendeeIdentity
        extend T::Sig
        include Crystalline::MetadataFields

        # The attendee's full name.
        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}
        # Your own id for the attendee, unique within the event. A later row with the same external id updates this attendee.
        field(
          :external_id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("external_id")}}
        )
        # The attendee's email.
        field(
          :email,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("email")}}
        )
        # The attendee's phone in E.164 form.
        field(
          :phone,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("phone")}}
        )
        # Where the attendee works.
        field(
          :company,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("company")}}
        )
        # Where the attendee lives.
        field(
          :city,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("city")}}
        )
        # Accounts the attendee is known to hold, at most 20.
        field(
          :handles,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::Handle)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("handles")}}
        )

        sig {
          params(
            name: ::String,
            external_id: T.nilable(::String),
            email: T.nilable(::String),
            phone: T.nilable(::String),
            company: T.nilable(::String),
            city: T.nilable(::String),
            handles: T.nilable(T::Array[Models::Shared::Handle])
          )
            .void
        }
        def initialize(name:, external_id: nil, email: nil, phone: nil, company: nil, city: nil, handles: nil)
          @name = name
          @external_id = external_id
          @email = email
          @phone = phone
          @company = company
          @city = city
          @handles = handles
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @external_id == other.external_id
          return false unless @email == other.email
          return false unless @phone == other.phone
          return false unless @company == other.company
          return false unless @city == other.city
          return false unless @handles == other.handles
          true
        end
      end
    end
  end
end
