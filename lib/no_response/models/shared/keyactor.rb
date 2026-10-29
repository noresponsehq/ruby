# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class KeyActor
        extend T::Sig
        include Crystalline::MetadataFields

        # The public id of the workspace API key that made the change.
        field(
          :key_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("key_id"), required: true}}
        )

        field :type, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("type"), required: true}}

        sig { params(key_id: ::String, type: ::String).void }
        def initialize(key_id:, type: "api_key")
          @key_id = key_id
          unless type == "api_key"
            raise ArgumentError, "Invalid value for type"
          end

          @type = "api_key"
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @key_id == other.key_id
          return false unless @type == other.type
          true
        end
      end
    end
  end
end
