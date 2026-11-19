# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ExportPeopleRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field :group_id, ::String, {'path_param': {'field_name': "group_id", 'style': "simple", 'explode': false}}
        # Read people after this one.
        field(
          :after,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "after", 'style': "form", 'explode': true}}
        )
        # Only people with this decision; undecided for none yet.
        field(
          :decision,
          Crystalline::Nilable.new(Models::Shared::ListPeopleDecision),
          {'query_param': {'field_name': "decision", 'style': "form", 'explode': true}}
        )
        # Only people with this role; unstated for people whose role was not given.
        field(
          :role,
          Crystalline::Nilable.new(Models::Shared::ListPeopleRole),
          {'query_param': {'field_name': "role", 'style': "form", 'explode': true}}
        )
        # At most this many people.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig {
          params(
            group_id: ::String,
            after: T.nilable(::String),
            decision: T.nilable(Models::Shared::ListPeopleDecision),
            role: T.nilable(Models::Shared::ListPeopleRole),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(group_id:, after: nil, decision: nil, role: nil, limit: 100)
          @group_id = group_id
          @after = after
          @decision = decision
          @role = role
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @group_id == other.group_id
          return false unless @after == other.after
          return false unless @decision == other.decision
          return false unless @role == other.role
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
