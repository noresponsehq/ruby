# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # GET /v1/workspaces/{workspace_id}/invites: the workspace's pending invites, oldest first, at most 50, with no token.
      class InviteList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::Invite),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig { params(items: T::Array[Models::Shared::Invite]).void }
        def initialize(items:)
          @items = items
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @items == other.items
          true
        end
      end
    end
  end
end
