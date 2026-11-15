# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class CancelScreeningRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :group_id, ::String, {'path_param': {'field_name': "group_id", 'style': "simple", 'explode': false}}

        field(
          :screening_id,
          ::String,
          {'path_param': {'field_name': "screening_id", 'style': "simple", 'explode': false}}
        )

        field :body, Models::Shared::ScreeningCancelRequest, {'request': {'media_type': "application/json"}}

        sig { params(group_id: ::String, screening_id: ::String, body: Models::Shared::ScreeningCancelRequest).void }
        def initialize(group_id:, screening_id:, body:)
          @group_id = group_id
          @screening_id = screening_id
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @group_id == other.group_id
          return false unless @screening_id == other.screening_id
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
