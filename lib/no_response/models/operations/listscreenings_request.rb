# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListScreeningsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :group_id, ::String, {'path_param': {'field_name': "group_id", 'style': "simple", 'explode': false}}
        # Read screenings older than this one.
        field(
          :before,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "before", 'style': "form", 'explode': true}}
        )
        # At most this many items.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig { params(group_id: ::String, before: T.nilable(::String), limit: T.nilable(::Integer)).void }
        def initialize(group_id:, before: nil, limit: 20)
          @group_id = group_id
          @before = before
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @group_id == other.group_id
          return false unless @before == other.before
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
