# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # GET /v1/workspaces/{workspace_id}/members: the workspace's active members, oldest first, at most 100.
      class MemberList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::Member),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig { params(items: T::Array[Models::Shared::Member]).void }
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
