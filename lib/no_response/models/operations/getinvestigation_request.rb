# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class GetInvestigationRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :investigation_id,
          ::String,
          {'path_param': {'field_name': "investigation_id", 'style': "simple", 'explode': false}}
        )

        sig { params(investigation_id: ::String).void }
        def initialize(investigation_id:)
          @investigation_id = investigation_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @investigation_id == other.investigation_id
          true
        end
      end
    end
  end
end
