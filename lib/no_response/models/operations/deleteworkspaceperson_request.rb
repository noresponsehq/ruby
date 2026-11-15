# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class DeleteWorkspacePersonRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :person_id, ::String, {'path_param': {'field_name': "person_id", 'style': "simple", 'explode': false}}

        sig { params(person_id: ::String).void }
        def initialize(person_id:)
          @person_id = person_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @person_id == other.person_id
          true
        end
      end
    end
  end
end
