# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class JudgeWorkspacePersonRecordRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :person_id, ::String, {'path_param': {'field_name': "person_id", 'style': "simple", 'explode': false}}

        field :body, Models::Shared::RecordVerdictRequest, {'request': {'media_type': "application/json"}}

        sig { params(person_id: ::String, body: Models::Shared::RecordVerdictRequest).void }
        def initialize(person_id:, body:)
          @person_id = person_id
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @person_id == other.person_id
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
