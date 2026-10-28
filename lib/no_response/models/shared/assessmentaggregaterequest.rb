# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Count this environment's assessments created in [from,to) by bucket, from counts kept as each assessment is first answered, not by scanning assessments. Each assessment counts once, by its first answer (the answer served when it was first answered); later revisions and late results do not count it again, and late_flips counts its later account decision changes. from and to start a bucket (an hour, a UTC day, or a week from Monday 00:00 UTC), cover at most 366 days (31 for hour buckets) and from is inside the retention period. The filters are POST /v1/assessments/search's and describe the first answer, so a cell drills down to search with the same filters, revision first and the cell's bucket as from and to. Counts hold no identifier and stay when an assessment or account is deleted or erased; they expire with retention and go with the workspace. Reasons are counted by code and impact band, not by weight. No Idempotency-Key.
      class AssessmentAggregateRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The first bucket's start.
        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}
        # The end, excluded: the start of the bucket after the last.
        field :to, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("to"), required: true}}
        # The period each count covers, in UTC; a week starts on Monday.
        field(
          :bucket,
          Models::Shared::Bucket,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("bucket"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Bucket, false)
            }
          }
        )
        # At most two dimensions to count by, of which at most one is reason, lane, country or asn. An assessment counts once in each of its reasons and incomplete lanes, so those groups can add up to more than the bucket's count.
        field(
          :group_by,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::AggregateDimension)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_by")}}
        )
        # count: each bucket's count and groups. score_histogram: first answers by flow and 5-point score bucket. late_flips: changes of an assessment's account decision for its flow after its first answer, by from, to and delay.
        field(
          :metrics,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::AssessmentAggregateRequestMetric)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("metrics")}}
        )
        # The event an assessment is made for: account_creation (a user creates an account), login (a user returns to an existing account) or purchase (a payment or a credit grant). The account's risk is reported with the decision for this flow.
        field(
          :flow,
          Crystalline::Nilable.new(Models::Shared::Flow),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("flow"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Flow, true)
            }
          }
        )
        # complete: final; nothing is still running. A lane that failed or missed its 10 s deadline stays listed in incomplete_sources, and confidence is lower. partial: a recommendation exists and at least one lane is still running or did not settle (see incomplete_sources). pending: nothing usable before the deadline; no recommendation yet, poll or wait for the webhook.
        field(
          :status,
          Crystalline::Nilable.new(Models::Shared::Status),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("status"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Status, true)
            }
          }
        )
        # The recommended action: allow, step_up or review. Your application applies it.
        field(
          :recommendation,
          Crystalline::Nilable.new(Models::Shared::Recommendation),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("recommendation"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Recommendation, true)
            }
          }
        )
        # An assessment's own decision: block when its stored risk.block is true, otherwise its recommendation. It is not the account's decision or held-admission state.
        field(
          :decision,
          Crystalline::Nilable.new(Models::Shared::Decision),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("decision"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Decision, true)
            }
          }
        )
        # Which answer of each assessment the filters describe: latest, the latest stored revision, or first, the first answer, as served when the assessment was first answered (POST /v1/assessments/aggregate counts first answers). A cell of an aggregate drills down to POST /v1/assessments/search with the same filters, revision first and the cell's bucket as from and to.
        field(
          :revision,
          Crystalline::Nilable.new(Models::Shared::AnswerRevision),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("revision"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::AnswerRevision, true)
            }
          }
        )
        # The most groups answered: the largest over the whole range, then by value. groups_truncated says when there were more.
        field(
          :limit,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("limit")}}
        )

        sig {
          params(
            from: ::String,
            to: ::String,
            bucket: Models::Shared::Bucket,
            group_by: T.nilable(T::Array[Models::Shared::AggregateDimension]),
            metrics: T.nilable(T::Array[Models::Shared::AssessmentAggregateRequestMetric]),
            flow: T.nilable(Models::Shared::Flow),
            status: T.nilable(Models::Shared::Status),
            recommendation: T.nilable(Models::Shared::Recommendation),
            decision: T.nilable(Models::Shared::Decision),
            revision: T.nilable(Models::Shared::AnswerRevision),
            limit: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          from:,
          to:,
          bucket:,
          group_by: nil,
          metrics: nil,
          flow: nil,
          status: nil,
          recommendation: nil,
          decision: nil,
          revision: nil,
          limit: 20
        )
          @from = from
          @to = to
          @bucket = bucket
          @group_by = group_by
          @metrics = metrics
          @flow = flow
          @status = status
          @recommendation = recommendation
          @decision = decision
          @revision = revision
          @limit = limit
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @bucket == other.bucket
          return false unless @group_by == other.group_by
          return false unless @metrics == other.metrics
          return false unless @flow == other.flow
          return false unless @status == other.status
          return false unless @recommendation == other.recommendation
          return false unless @decision == other.decision
          return false unless @revision == other.revision
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
