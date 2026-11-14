# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # A person the group protects.
      class Principal
        extend T::Sig
        include Crystalline::MetadataFields

        # The principal's name.
        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}
        # Other names the principal goes by, at most 10.
        field(
          :aliases,
          Crystalline::Nilable.new(Crystalline::Array.new(::String)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("aliases")}}
        )

        sig { params(name: ::String, aliases: T.nilable(T::Array[::String])).void }
        def initialize(name:, aliases: nil)
          @name = name
          @aliases = aliases
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @aliases == other.aliases
          true
        end
      end
    end
  end
end
