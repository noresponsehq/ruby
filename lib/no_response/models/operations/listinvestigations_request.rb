# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class ListInvestigationsRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :person_id,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "person_id", 'style': "form", 'explode': true}}
        )

        field(
          :before,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "before", 'style': "form", 'explode': true}}
        )

        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'query_param': {'field_name': "limit", 'style': "form", 'explode': true}}
        )

        sig { params(person_id: T.nilable(::String), before: T.nilable(::String), limit: T.nilable(::Integer)).void }
        def initialize(person_id: nil, before: nil, limit: 100)
          @person_id = person_id
          @before = before
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @person_id == other.person_id
          return false unless @before == other.before
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
