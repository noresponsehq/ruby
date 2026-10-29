# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class UsageCount
        extend T::Sig
        include Crystalline::MetadataFields

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

        field :day, ::String, {'format_json': {'letter_case': ::NoResponse::Utils.field_name("day"), required: true}}
        # assessments: assessments admitted. webhook_deliveries: events sent to endpoints, one per event per endpoint. key_usage_events: key-usage events accepted.
        field(
          :metric,
          Models::Shared::Metric,
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("metric"),
              required: true,
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::Metric, false)
            }
          }
        )

        field(
          :count,
          ::Integer,
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("count"), required: true}}
        )
        # assessments only.
        field(
          :flow,
          Crystalline::Nilable.new(Models::Shared::UsageCountFlow),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("flow"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::UsageCountFlow, true)
            }
          }
        )
        # assessments only.
        field(
          :depth,
          Crystalline::Nilable.new(Models::Shared::UsageCountDepth),
          {
            'format_json': {
              'letter_case': ::NoResponse::Utils.field_name("depth"),
              'decoder': ::NoResponse::Utils.open_enum_from_string(Models::Shared::UsageCountDepth, true)
            }
          }
        )

        sig {
          params(
            environment: Models::Shared::AuditSettingsEnvironment,
            day: ::String,
            metric: Models::Shared::Metric,
            count: ::Integer,
            flow: T.nilable(Models::Shared::UsageCountFlow),
            depth: T.nilable(Models::Shared::UsageCountDepth)
          )
            .void
        }
        def initialize(environment:, day:, metric:, count:, flow: nil, depth: nil)
          @environment = environment
          @day = day
          @metric = metric
          @count = count
          @flow = flow
          @depth = depth
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @environment == other.environment
          return false unless @day == other.day
          return false unless @metric == other.metric
          return false unless @count == other.count
          return false unless @flow == other.flow
          return false unless @depth == other.depth
          true
        end
      end
    end
  end
end
