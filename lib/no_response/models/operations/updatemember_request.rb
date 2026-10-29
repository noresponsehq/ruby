# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class UpdateMemberRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.
        field(
          :workspace_id,
          ::String,
          {'path_param': {'field_name': "workspace_id", 'style': "simple", 'explode': false}}
        )
        # The member's mem_ id. A member of another workspace, or a removed one, answers 404.
        field :member_id, ::String, {'path_param': {'field_name': "member_id", 'style': "simple", 'explode': false}}

        field :body, Models::Shared::MemberUpdateRequest, {'request': {'media_type': "application/json"}}

        sig { params(workspace_id: ::String, member_id: ::String, body: Models::Shared::MemberUpdateRequest).void }
        def initialize(workspace_id:, member_id:, body:)
          @workspace_id = workspace_id
          @member_id = member_id
          @body = body
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @member_id == other.member_id
          return false unless @body == other.body
          true
        end
      end
    end
  end
end
