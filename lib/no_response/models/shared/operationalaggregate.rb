# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # One repeatable-read snapshot of retained request diagnostics or webhook attempts. Capture can have gaps and these counts are not a billing ledger. Unattributed keys include older requests and member requests. Queue state is current retained work, not a delivery success denominator.
      class OperationalAggregate
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :source,
          Models::Shared::Source,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("source"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Source, false)
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
          :bucket,
          Models::Shared::RequestAggregateRequestBucket,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("bucket"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::RequestAggregateRequestBucket, false)
            }
          }
        )

        field(
          :totals,
          Models::Shared::OperationalAggregateTotals,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("totals"), required: true}}
        )
        # Nonempty UTC buckets in ascending order. Counts include all retained matching attempts, without the log page limit.
        field(
          :buckets,
          Crystalline::Array.new(Models::Shared::OperationalAggregateBucket),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("buckets"), required: true}}
        )

        field(
          :schema_version,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("schema_version"), required: true}}
        )

        field(
          :capture,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("capture"), required: true}}
        )

        field(
          :population,
          ::String,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("population"), required: true}}
        )
        # Current retained delivery queue, independent of the requested attempt window and status filter. Endpoint filter applies. Does not prove customer enforcement execution.
        field(
          :queue,
          Crystalline::Nilable.new(Models::Shared::OperationalAggregateQueue),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("queue")}}
        )

        sig {
          params(
            source: Models::Shared::Source,
            from: ::String,
            to: ::String,
            as_of: ::String,
            retained_from: ::String,
            retention_days: ::Integer,
            bucket: Models::Shared::RequestAggregateRequestBucket,
            totals: Models::Shared::OperationalAggregateTotals,
            buckets: T::Array[Models::Shared::OperationalAggregateBucket],
            schema_version: ::String,
            capture: ::String,
            population: ::String,
            queue: T.nilable(Models::Shared::OperationalAggregateQueue)
          )
            .void
        }
        def initialize(
          source:,
          from:,
          to:,
          as_of:,
          retained_from:,
          retention_days:,
          bucket:,
          totals:,
          buckets:,
          schema_version: "1",
          capture: "best_effort",
          population: "retained_attempts",
          queue: nil
        )
          @source = source
          @from = from
          @to = to
          @as_of = as_of
          @retained_from = retained_from
          @retention_days = retention_days
          @bucket = bucket
          @totals = totals
          @buckets = buckets
          unless schema_version == "1"
            raise ArgumentError, "Invalid value for schema_version"
          end

          @schema_version = "1"
          unless capture == "best_effort"
            raise ArgumentError, "Invalid value for capture"
          end

          @capture = "best_effort"
          unless population == "retained_attempts"
            raise ArgumentError, "Invalid value for population"
          end

          @population = "retained_attempts"
          @queue = queue
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @source == other.source
          return false unless @from == other.from
          return false unless @to == other.to
          return false unless @as_of == other.as_of
          return false unless @retained_from == other.retained_from
          return false unless @retention_days == other.retention_days
          return false unless @bucket == other.bucket
          return false unless @totals == other.totals
          return false unless @buckets == other.buckets
          return false unless @schema_version == other.schema_version
          return false unless @capture == other.capture
          return false unless @population == other.population
          return false unless @queue == other.queue
          true
        end
      end
    end
  end
end
