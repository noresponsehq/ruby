# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Three separately defined populations with independent denominators. Interpret each section within its own population; their totals do not form a conversion funnel. All counts and retention come from one snapshot. Requests above the population or query budget are refused without truncation.
      class WorkspaceOperationsSummary
        extend T::Sig
        include Crystalline::MetadataFields

        # The workspace id, which is also its live environment's workspace id; the test environment's is the same id with :test appended. A workspace created through the API is tnt_ and a 26-character ULID.
        field(
          :workspace_id,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("workspace_id"), required: true}}
        )

        field(
          :environment,
          Models::Shared::AuditSettingsEnvironment,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("environment"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::AuditSettingsEnvironment, false)
            }
          }
        )

        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}

        field :to, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("to"), required: true}}

        field(
          :as_of,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("as_of"), required: true}}
        )

        field(
          :retained_from,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retained_from"), required: true}}
        )

        field(
          :retention_days,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retention_days"), required: true}}
        )

        field(
          :records_read,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("records_read"), required: true}}
        )
        # Accounts whose current completed assessment was created in the selected window and remains retained at as_of. The effective account feedback head is observed at as_of, including explicit unknown reports. Customer-reported labels and unlabelled accounts have separate counts. Superseded labels are excluded.
        field(
          :outcomes,
          Models::Shared::Outcomes,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("outcomes"), required: true}}
        )
        # Retained customer enforcement report rows created in [from,to), one row per account/risk_version/flow/action. A later applied report can replace failed at the original created_at; retries are not additional attempts here. applied_coverage divides reported_applied by report rows, including explicit action none; it is not independently verified execution, all requested actions, or prevented fraud. Unreported actions are unknown.
        field(
          :enforcements,
          Models::Shared::Enforcements,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("enforcements"), required: true}}
        )
        # Reviews created in [from,to) whose review and current account assessment remain retained. Status and assignment are current at as_of, not a transition history. label_coverage numerator is resolved reviews labeled benign or abuse; denominator is resolved reviews. Inconclusive is not a known outcome. Review conclusions do not change account feedback or enforcement.
        field(
          :reviews,
          Models::Shared::Reviews,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("reviews"), required: true}}
        )

        field(
          :row_budget,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("row_budget"), required: true}}
        )

        field(
          :truncated,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("truncated"), required: true}}
        )

        sig {
          params(
            workspace_id: ::String,
            environment: Models::Shared::AuditSettingsEnvironment,
            from: ::String,
            to: ::String,
            as_of: ::String,
            retained_from: ::String,
            retention_days: ::Integer,
            records_read: ::Integer,
            outcomes: Models::Shared::Outcomes,
            enforcements: Models::Shared::Enforcements,
            reviews: Models::Shared::Reviews,
            row_budget: ::Integer,
            truncated: T::Boolean
          )
            .void
        }
        def initialize(
          workspace_id:,
          environment:,
          from:,
          to:,
          as_of:,
          retained_from:,
          retention_days:,
          records_read:,
          outcomes:,
          enforcements:,
          reviews:,
          row_budget: 100_000,
          truncated: false
        )
          @workspace_id = workspace_id
          @environment = environment
          @from = from
          @to = to
          @as_of = as_of
          @retained_from = retained_from
          @retention_days = retention_days
          @records_read = records_read
          @outcomes = outcomes
          @enforcements = enforcements
          @reviews = reviews
          unless row_budget == 100_000
            raise ArgumentError, "Invalid value for row_budget"
          end

          @row_budget = 100_000
          unless truncated == false
            raise ArgumentError, "Invalid value for truncated"
          end

          @truncated = false
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @workspace_id == other.workspace_id
          return false unless @environment == other.environment
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @as_of == other.as_of
          return false unless @retained_from == other.retained_from
          return false unless @retention_days == other.retention_days
          return false unless @records_read == other.records_read
          return false unless @outcomes == other.outcomes
          return false unless @enforcements == other.enforcements
          return false unless @reviews == other.reviews
          return false unless @row_budget == other.row_budget
          return false unless @truncated == other.truncated
          true
        end
      end
    end
  end
end
