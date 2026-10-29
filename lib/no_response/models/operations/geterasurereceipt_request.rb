# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class GetErasureReceiptRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :erasure_id, ::String, {'path_param': {'field_name': "erasure_id", 'style': "simple", 'explode': false}}

        sig { params(erasure_id: ::String).void }
        def initialize(erasure_id:)
          @erasure_id = erasure_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @erasure_id == other.erasure_id
          true
        end
      end
    end
  end
end
