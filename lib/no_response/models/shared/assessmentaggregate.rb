# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Body of the 200 answer to POST /v1/assessments/aggregate: one entry per bucket of [from,to), empty buckets included. Counts are of first answers and stay when an assessment or account is deleted or erased; search returns only assessments still retained.
      class AssessmentAggregate
        extend T::Sig
        include Crystalline::MetadataFields

        field :from, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("from"), required: true}}

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

        field(
          :group_by,
          Crystalline::Array.new(Models::Shared::AggregateDimension),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("group_by"), required: true}}
        )

        field(
          :metrics,
          Crystalline::Array.new(Models::Shared::AssessmentAggregateMetric),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("metrics"), required: true}}
        )
        # The time zone whose local midnight started each day and week bucket, as requested; UTC when the request named none.
        field(
          :time_zone,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("time_zone"), required: true}}
        )
        # true when more groups had counts than limit allowed.
        field(
          :groups_truncated,
          Crystalline::Boolean.new,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("groups_truncated"), required: true}}
        )

        field(
          :buckets,
          Crystalline::Array.new(Models::Shared::AggregateBucket),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("buckets"), required: true}}
        )
        # Version of the body shape.
        field(
          :schema_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schema_version"), required: true}}
        )
        # Captured in the same database snapshot as the counts. Capture start times describe when counting began, not the earliest creation time counted: an older assessment may first answer later. Older outcomes are not inferred to be absent. Erased detail cannot be returned by drill-down even while its anonymous count remains.
        field(
          :coverage,
          Crystalline::Nilable.new(Models::Shared::AssessmentAggregateCoverage),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("coverage")}}
        )
        # The calling workspace's configured retention period in days. Default 365 (12 months), which is also the maximum: a workspace may only shorten it, to at least 1 day. Each record expires from its own created_at; see assessment expires_at.
        field(
          :retention_days,
          Crystalline::Nilable.new(::Integer),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("retention_days")}}
        )

        sig {
          params(
            from: ::String,
            to: ::String,
            bucket: Models::Shared::Bucket,
            group_by: T::Array[Models::Shared::AggregateDimension],
            metrics: T::Array[Models::Shared::AssessmentAggregateMetric],
            time_zone: ::String,
            groups_truncated: T::Boolean,
            buckets: T::Array[Models::Shared::AggregateBucket],
            schema_version: ::String,
            coverage: T.nilable(Models::Shared::AssessmentAggregateCoverage),
            retention_days: T.nilable(::Integer)
          )
            .void
        }
        def initialize(
          from:,
          to:,
          bucket:,
          group_by:,
          metrics:,
          time_zone:,
          groups_truncated:,
          buckets:,
          schema_version: "1",
          coverage: nil,
          retention_days: 365
        )
          @from = from
          @to = to
          @bucket = bucket
          @group_by = group_by
          @metrics = metrics
          @time_zone = time_zone
          @groups_truncated = groups_truncated
          @buckets = buckets
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
          @coverage = coverage
          @retention_days = retention_days
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @bucket == other.bucket
          return false unless @group_by == other.group_by
          return false unless @metrics == other.metrics
          return false unless @time_zone == other.time_zone
          return false unless @groups_truncated == other.groups_truncated
          return false unless @buckets == other.buckets
          return false unless @schema_version == other.schema_version
          return false unless @coverage == other.coverage
          return false unless @retention_days == other.retention_days
          true
        end
      end
    end
  end
end
