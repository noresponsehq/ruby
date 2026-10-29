# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Body of the 200 answer to GET /v1/workspaces/{workspace_id}/usage: what the workspace's environments were metered for on each UTC day from from through to. Each billable unit is counted once, where it becomes final: an assessment when it is admitted (by flow and depth), a webhook delivery once per event per endpoint (retries and replays add nothing), and a key-usage event once when the ingest accepts it. A count does not change when the assessment, account or workspace is later deleted. A day, environment or metric with nothing counted has no item. No prices, limits or billing.
      class Usage
        extend T::Sig
        include Crystalline::MetadataFields

        # The workspace id, which is also its live environment's workspace id; the test environment's is the same id with :test appended. A workspace created through the API is tnt_ and a 26-character ULID.
        field(
          :workspace_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("workspace_id"), required: true}}
        )
        # The first UTC day covered.
        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}
        # The last UTC day covered, included.
        field :to, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("to"), required: true}}
        # Ordered by environment (live first), then day, metric, flow and depth.
        field(
          :items,
          Crystalline::Array.new(Models::Shared::UsageCount),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("items"), required: true}}
        )

        sig {
          params(workspace_id: ::String, from: ::String, to: ::String, items: T::Array[Models::Shared::UsageCount]).void
        }
        def initialize(workspace_id:, from:, to:, items:)
          @workspace_id = workspace_id
          @from = from
          @to = to
          @items = items
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @items == other.items
          true
        end
      end
    end
  end
end
