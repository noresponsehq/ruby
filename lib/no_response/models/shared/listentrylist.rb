# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # GET /v1/workspaces/{workspace_id}/lists/{environment}: every entry of the environment's list, newest first. An environment holds at most 10,000 entries.
      class ListEntryList
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :items,
          Crystalline::Array.new(Models::Shared::ListEntry),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig { params(items: T::Array[Models::Shared::ListEntry]).void }
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
