# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A place a post names, as the platform shows it.
      class PostPlace
        extend T::Sig
        include Crystalline::MetadataFields

        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}
        # The platform's own id of the place.
        field(
          :id,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("id")}}
        )

        field(
          :address,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("address")}}
        )

        field(
          :city,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("city")}}
        )

        field(
          :latitude,
          Crystalline::Nilable.new(::Float),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("latitude")}}
        )

        field(
          :longitude,
          Crystalline::Nilable.new(::Float),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("longitude")}}
        )

        sig {
          params(
            name: ::String,
            id: T.nilable(::String),
            address: T.nilable(::String),
            city: T.nilable(::String),
            latitude: T.nilable(::Float),
            longitude: T.nilable(::Float)
          )
            .void
        }
        def initialize(name:, id: nil, address: nil, city: nil, latitude: nil, longitude: nil)
          @name = name
          @id = id
          @address = address
          @city = city
          @latitude = latitude
          @longitude = longitude
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @id == other.id
          return false unless @address == other.address
          return false unless @city == other.city
          return false unless @latitude == other.latitude
          return false unless @longitude == other.longitude
          true
        end
      end
    end
  end
end
