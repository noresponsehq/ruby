# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Metric - assessments: assessments admitted. webhook_deliveries: events sent to endpoints, one per event per endpoint. key_usage_events: key-usage events accepted. screenings: people a screening recorded a final result for, one per person per screening; a failed person counts only when its lookups were kept.
      class Metric
        include ::Crystalline::Enum
        enums do
          ASSESSMENTS = new("assessments")
          WEBHOOK_DELIVERIES = new("webhook_deliveries")
          KEY_USAGE_EVENTS = new("key_usage_events")
          SCREENINGS = new("screenings")
        end

        open!
      end
    end
  end
end
