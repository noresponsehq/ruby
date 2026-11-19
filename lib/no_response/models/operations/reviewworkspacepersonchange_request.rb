# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ReviewWorkspacePersonChangeRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :person_id, ::String, {'path_param': {'field_name': "person_id", 'style': "simple", 'explode': false}}

        field :change_id, ::String, {'path_param': {'field_name': "change_id", 'style': "simple", 'explode': false}}

        field :body, Models::Shared::ScreeningCancelRequest, {'request': {'media_type': "application/json"}}

        sig { params(person_id: ::String, change_id: ::String, body: Models::Shared::ScreeningCancelRequest).void }
        def initialize(person_id:, change_id:, body:)
          @person_id = person_id
          @change_id = change_id
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @person_id == other.person_id
          return false unless @change_id == other.change_id
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
