# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListAccountsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # next_cursor from an earlier page, unchanged. Absent, the list starts from the oldest change.
        field(
          :changed_since,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "changed_since", 'style': "form", 'explode': true}}
        )
        # Most accounts per page.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )
        # true lists only accounts with no applied enforcement at their current risk_version that have a decision other than allow for some flow or a hold no later applied enforcement resolved.
        field(
          :unenforced,
          Crystalline::Nilable.new(Crystalline::Boolean.new),
          {'query_param': {'field_name': "unenforced", 'style': "form", 'explode': true}}
        )

        sig {
          params(changed_since: T.nilable(::String), limit: T.nilable(::Integer), unenforced: T.nilable(T::Boolean))
            .void
        }
        def initialize(changed_since: nil, limit: 50, unenforced: false)
          @changed_since = changed_since
          @limit = limit
          @unenforced = unenforced
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @changed_since == other.changed_since
          return false unless @limit == other.limit
          return false unless @unenforced == other.unenforced
          true
        end
      end
    end
  end
end
