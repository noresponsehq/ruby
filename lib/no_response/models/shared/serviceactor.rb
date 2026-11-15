# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ServiceActor
        extend T::Sig
        include Crystalline::MetadataFields

        # The NoResponse service that made the change with no person acting, such as replenisher, which replaces dead platform sessions in NoResponse's own workspace.
        field :name, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("name"), required: true}}

        field :type, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("type"), required: true}}

        sig { params(name: ::String, type: ::String).void }
        def initialize(name:, type: "service")
          @name = name
          unless type == "service"
            raise ArgumentError, "Invalid value for type"
          end

          @type = "service"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @name == other.name
          return false unless @type == other.type
          true
        end
      end
    end
  end
end
