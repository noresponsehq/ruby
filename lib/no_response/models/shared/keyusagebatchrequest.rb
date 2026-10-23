# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # POST /v1/key_usage/batches body: facts about requests made with API keys your platform issued to your accounts, one event per request. Each event names the key by the SHA-256 that the assessment's issued_credential.sha256 carried, not the key itself. The SDKs buffer events and send them in the background. A batch holds 1 to 500 events and at most 256 KiB. Idempotency-Key is required and binds the body as on POST /v1/assessments, so a retried batch is counted once.
      class KeyUsageBatchRequest
        extend T::Sig
        include Crystalline::MetadataFields

        field(
          :events,
          Crystalline::Array.new(Models::Shared::KeyUsageEvent),
          {'format_json': {'letter_case': ::NoResponse::Utils.field_name("events"), required: true}}
        )

        sig { params(events: T::Array[Models::Shared::KeyUsageEvent]).void }
        def initialize(events:)
          @events = events
        end

        sig { params(other: T.untyped).returns(T::Boolean) }
        def ==(other)
          return false unless other.is_a?(self.class)
          return false unless @events == other.events
          true
        end
      end
    end
  end
end
