# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Security
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :api_key,
          ::String,
          {'security': {'scheme': true, 'type': "http", 'sub_type': "bearer", 'field_name': "Authorization"}}
        )

        sig { params(api_key: ::String).void }
        def initialize(api_key:)
          @api_key = api_key
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @api_key == other.api_key
          true
        end
      end
    end
  end
end
