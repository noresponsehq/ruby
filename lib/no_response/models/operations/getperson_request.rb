# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class GetPersonRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :group_id, ::String, {'path_param': {'field_name': "group_id", 'style': "simple", 'explode': false}}

        field :person_id, ::String, {'path_param': {'field_name': "person_id", 'style': "simple", 'explode': false}}

        sig { params(group_id: ::String, person_id: ::String).void }
        def initialize(group_id:, person_id:)
          @group_id = group_id
          @person_id = person_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @group_id == other.group_id
          return false unless @person_id == other.person_id
          true
        end
      end
    end
  end
end
