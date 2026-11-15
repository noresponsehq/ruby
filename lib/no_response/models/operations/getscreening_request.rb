# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class GetScreeningRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :group_id, ::String, {'path_param': {'field_name': "group_id", 'style': "simple", 'explode': false}}

        field(
          :screening_id,
          ::String,
          {'path_param': {'field_name': "screening_id", 'style': "simple", 'explode': false}}
        )

        sig { params(group_id: ::String, screening_id: ::String).void }
        def initialize(group_id:, screening_id:)
          @group_id = group_id
          @screening_id = screening_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @group_id == other.group_id
          return false unless @screening_id == other.screening_id
          true
        end
      end
    end
  end
end
