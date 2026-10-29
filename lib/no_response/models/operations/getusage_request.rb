# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Operations

      class GetUsageRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # Your workspace id, as each key lists it in workspace_id. Another workspace, a malformed id and a test environment's id answer 404.
        field(
          :workspace_id,
          ::String,
          {'path_param': {'field_name': "workspace_id", 'style': "simple", 'explode': false}}
        )
        # The first UTC day, as YYYY-MM-DD.
        field(
          :from,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "from", 'style': "form", 'explode': true}}
        )
        # The last UTC day, included, as YYYY-MM-DD; no later than today.
        field(
          :to,
          Crystalline::Nilable.new(::String),
          {'query_param': {'field_name': "to", 'style': "form", 'explode': true}}
        )

        sig { params(workspace_id: ::String, from: T.nilable(::String), to: T.nilable(::String)).void }
        def initialize(workspace_id:, from: nil, to: nil)
          @workspace_id = workspace_id
          @from = from
          @to = to
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @from == other.from
          return false unless @to == other.to
          true
        end
      end
    end
  end
end
