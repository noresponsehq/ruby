# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class RemoveMemberRequest
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

        sig { params(workspace_id: ::String, member_id: ::String).void }
        def initialize(workspace_id:, member_id:)
          @workspace_id = workspace_id
          @member_id = member_id
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @member_id == other.member_id
          true
        end
      end
    end
  end
end
