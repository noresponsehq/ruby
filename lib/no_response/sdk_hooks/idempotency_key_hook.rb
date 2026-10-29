# typed: true
# frozen_string_literal: true

require 'securerandom'

module NoResponse
  module SDKHooks
    # Sends a fresh UUID as the Idempotency-Key when the caller gave none. The
    # hook runs once per call, before any retry, so every attempt carries the
    # same key.
    class IdempotencyKeyHook < AbstractSDKHook
      extend T::Sig

      OPERATIONS = %w[createAssessment recordAssessmentOutcome recordKeyUsage recordAccountOutcome changeLists createPolicyEvaluation].freeze

      sig { override.params(hook_ctx: BeforeRequestHookContext, request: Faraday::Request).returns(Faraday::Request) }
      def before_request(hook_ctx:, request:)
        if OPERATIONS.include?(hook_ctx.operation_id) && !request.headers.key?('Idempotency-Key')
          request.headers['Idempotency-Key'] = SecureRandom.uuid
        end
        request
      end
    end
  end
end
