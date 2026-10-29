# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Body of the 200 answer to GET /v1/workspaces/{workspace_id}/usage: what the workspace's environments were metered for on each UTC day from from through to. Each billable unit is counted once, where it becomes final: an assessment when it is admitted (by flow and depth), a webhook delivery once per event per endpoint (retries and replays add nothing), and a key-usage event once when the ingest accepts it. A count does not change when the assessment, account or workspace is later deleted. A day, environment or metric with nothing counted has no item. No prices or billing. console_lookups is the one limit: the live environment's daily cap on console lookups, as spent today.
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
        # The live environment's daily cap on assessments members make through the console (the playground), as spent on the current UTC day. Each console submission with a new Idempotency-Key spends one lookup; a replay spends nothing, and API keys and the test environment spend none. When used reaches limit, the next lookup answers 429 lookup_limit_reached until resets_at. The count is the one the cap enforces.
        field(
          :console_lookups,
          Crystalline::Nilable.new(Models::Shared::ConsoleLookups),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("console_lookups")}}
        )

        sig {
          params(
            workspace_id: ::String,
            from: ::String,
            to: ::String,
            items: T::Array[Models::Shared::UsageCount],
            console_lookups: T.nilable(Models::Shared::ConsoleLookups)
          )
            .void
        }
        def initialize(workspace_id:, from:, to:, items:, console_lookups: nil)
          @workspace_id = workspace_id
          @from = from
          @to = to
          @items = items
          @console_lookups = console_lookups
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @items == other.items
          return false unless @console_lookups == other.console_lookups
          true
        end
      end
    end
  end
end
