# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Count this environment's assessments created in [from,to) by bucket, from counts kept as each assessment is first answered, not by scanning assessments. Each assessment counts once, by its first answer (the answer served when it was first answered); later revisions and late results do not count it again, and late_flips counts its later account decision changes. from and to start a bucket (an hour, or a day or a week from Monday that starts at midnight in time_zone, UTC by default), cover at most 366 days (31 for hour buckets, 92 for day and week buckets in a time_zone other than UTC) and from is inside the retention period. The filters are POST /v1/assessments/search's and describe the first answer, so a cell drills down to search with the same filters, revision first and the cell's bucket as from and to. Counts hold no identifier and stay when an assessment or account is deleted or erased; they expire with retention and go with the workspace. Reasons are counted by code and impact band, not by weight. No Idempotency-Key. Select retained_first_answers for exact facet filters and pairs over retained detail. This mode supports count, score_histogram and score_outcomes, and refuses late_flips. It has a 31-day and 100000-record work budget.
      class AssessmentAggregateRequest
        extend T::Sig
        include Crystalline::MetadataFields

        # The first bucket's start.
        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}
        # The end, excluded: the start of the bucket after the last.
        field :to, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("to"), required: true}}
        # The period each count covers: an hour, or a day or a week (from Monday) in time_zone. Hour buckets are whole UTC hours in any time zone.
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
        # At most two dimensions to count by, of which at most one is reason, lane, country or asn. An assessment counts once in each of its reasons and incomplete lanes, so those groups can add up to more than the bucket's count. With population retained_first_answers, both dimensions can be facets; counts cover retained first answers only.
        field(
          :group_by,
          Crystalline::Nilable.new(Crystalline::Array.new(Models::Shared::AggregateDimension)),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_by")}}
        )
        # count: each bucket's count and groups. score_histogram: first answers by flow and 5-point score bucket. score_outcomes: the histogram's first answers that have a reported outcome, by flow, 5-point score bucket and the latest outcome reported for the assessment (POST /v1/assessments/{assessment_id}/outcomes); the rest of a bin has none reported. late_flips: changes of an assessment's account decision for its flow after its first answer, by from, to and delay.
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
        # Processing state, separate from evidence coverage. complete: final; nothing is still running, but unsupported, failed or unanswered lanes remain in incomplete_sources. partial: a recommendation exists and evidence is incomplete; assessment_url identifies continuing work when present. pending: no recommendation yet; poll or wait for the webhook. Finished processing does not mean all sources answered.
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
        # first_answers uses anonymous counters that can include erased detail. retained_first_answers computes exact intersections over retained first answers within 31 days. Requests exceeding the 100000-record work budget are refused.
        field(
          :population,
          Crystalline::Nilable.new(Models::Shared::Population),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("population"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Population, true)
            }
          }
        )

        field(
          :band,
          Crystalline::Nilable.new(Models::Shared::Band),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("band"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Band, true)
            }
          }
        )
        # A stable reason code. New codes may appear; ignore any you do not know.
        field(
          :reason,
          Crystalline::Nilable.new(Models::Shared::ReasonCode),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("reason"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::ReasonCode, true)
            }
          }
        )
        # The selected reason's served impact band. Requires reason.
        field(
          :impact,
          Crystalline::Nilable.new(Models::Shared::Impact),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("impact"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Impact, true)
            }
          }
        )
        # An evidence lane: accounts (account presence for email and username), phone, breach, domain (the email domain's registration) and ip.
        field(
          :lane,
          Crystalline::Nilable.new(Models::Shared::Lane),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("lane"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Lane, true)
            }
          }
        )

        field(
          :country,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("country")}}
        )

        field(
          :asn,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("asn")}}
        )
        # Inclusive lower score bound. Pending answers without a score do not match.
        field(
          :score_min,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_min")}}
        )
        # Inclusive upper score bound, at least score_min when both are supplied.
        field(
          :score_max,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("score_max")}}
        )
        # The list action captured at the first answer. Requires revision first. Older answers without captured list state do not match, including none.
        field(
          :list_match,
          Crystalline::Nilable.new(Models::Shared::ListMatch),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("list_match"),
              'decoder': ::NoResponse::Utils.enum_from_string(Models::Shared::ListMatch, true)
            }
          }
        )
        # The IANA time zone whose local midnight starts each day and week bucket, such as Europe/London or Asia/Kolkata; daylight saving changes make those days 23 or 25 hours long. A name the zone database does not know is refused (400 invalid_request naming time_zone). Day and week buckets in a zone other than UTC cover at most 92 days (400 invalid_request naming to); a year of them reads too many hourly counts to answer in time. Hour buckets stay whole UTC hours. Bucket starts, from and to stay instants. With the default population, a zone whose local midnight falls inside a UTC hour (a half-hour offset such as Asia/Kolkata) is refused for day and week buckets, as those counts are kept by the hour; retained_first_answers counts it.
        field(
          :time_zone,
          Crystalline::Nilable.new(::String),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("time_zone")}}
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
            population: T.nilable(Models::Shared::Population),
            band: T.nilable(Models::Shared::Band),
            reason: T.nilable(Models::Shared::ReasonCode),
            impact: T.nilable(Models::Shared::Impact),
            lane: T.nilable(Models::Shared::Lane),
            country: T.nilable(::String),
            asn: T.nilable(::Integer),
            score_min: T.nilable(::Integer),
            score_max: T.nilable(::Integer),
            list_match: T.nilable(Models::Shared::ListMatch),
            time_zone: T.nilable(::String),
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
          population: nil,
          band: nil,
          reason: nil,
          impact: nil,
          lane: nil,
          country: nil,
          asn: nil,
          score_min: nil,
          score_max: nil,
          list_match: nil,
          time_zone: "UTC",
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
          @population = population
          @band = band
          @reason = reason
          @impact = impact
          @lane = lane
          @country = country
          @asn = asn
          @score_min = score_min
          @score_max = score_max
          @list_match = list_match
          @time_zone = time_zone
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
          return false unless @population == other.population
          return false unless @band == other.band
          return false unless @reason == other.reason
          return false unless @impact == other.impact
          return false unless @lane == other.lane
          return false unless @country == other.country
          return false unless @asn == other.asn
          return false unless @score_min == other.score_min
          return false unless @score_max == other.score_max
          return false unless @list_match == other.list_match
          return false unless @time_zone == other.time_zone
          return false unless @limit == other.limit
          true
        end
      end
    end
  end
end
