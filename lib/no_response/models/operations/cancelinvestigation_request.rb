# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class CancelInvestigationRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :investigation_id,
          ::String,
          {'path_param': {'field_name': "investigation_id", 'style': "simple", 'explode': false}}
        )

        field :body, Models::Shared::ScreeningCancelRequest, {'request': {'media_type': "application/json"}}

        sig { params(investigation_id: ::String, body: Models::Shared::ScreeningCancelRequest).void }
        def initialize(investigation_id:, body:)
          @investigation_id = investigation_id
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @investigation_id == other.investigation_id
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
