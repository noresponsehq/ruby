# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class DeleteIntegrationRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Path segment, matched case-sensitively. A value that does not match the integration_id shape, or another workspace's id, answers 404.
        field(
          :integration_id,
          ::String,
          {'path_param': {'field_name': "integration_id", 'style': "simple", 'explode': false}}
        )

        sig { params(integration_id: ::String).void }
        def initialize(integration_id:)
          @integration_id = integration_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @integration_id == other.integration_id
          true
        end
      end
    end
  end
end
