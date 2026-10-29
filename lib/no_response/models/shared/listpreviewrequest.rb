# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Choose an addition or a removal. The preview performs no list, account, audit, outcome or outbox write.
      class ListPreviewRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # POST /v1/workspaces/{workspace_id}/lists/{environment} body. Adds one entry to the environment's list and, in the same change, re-decides every account it matches: each sends account.risk_changed when a decision changes. Needs the admin or owner role, or a management key of the environment.
        field(
          :add,
          Crystalline::Nilable.new(Models::Shared::ListEntryRequest),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("add")}}
        )

        field(
          :remove,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("remove")}}
        )

        sig { params(add: T.nilable(Models::Shared::ListEntryRequest), remove: T.nilable(::String)).void }
        def initialize(add: nil, remove: nil)
          @add = add
          @remove = remove
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @add == other.add
          return false unless @remove == other.remove
          true
        end
      end
    end
  end
end
