# typed: true
# frozen_string_literal: true

# Wait for a pending assessment. Hand-written beside the generated client.

module NoResponse
  # The assessment was still pending when the wait ran out. last is the
  # pending assessment from the final poll; the webhook delivers the result
  # when it settles.
  class WaitTimeoutError < StandardError
    attr_reader :assessment_id, :last

    def initialize(assessment_id, last)
      super("Assessment #{assessment_id} is still pending")
      @assessment_id = assessment_id
      @last = last
    end
  end

  module Wait
    DEFAULT_TIMEOUT_SECONDS = 30

    class << self

      # Poll client.assessments.get until the assessment is no longer pending,
      # sleeping for the Retry-After the API sends (at least 1 s) between
      # polls. Raises WaitTimeoutError once timeout seconds have passed.
      def wait(client, assessment_id, **options)
        poll(client.assessments, assessment_id, **options)
      end

      def poll(assessments, assessment_id, timeout: DEFAULT_TIMEOUT_SECONDS, sleeper: Kernel.method(:sleep),
               clock: -> { Process.clock_gettime(Process::CLOCK_MONOTONIC) })
        raise ArgumentError, 'timeout must be positive' unless timeout.positive?

        deadline = clock.call + timeout
        loop do
          remaining_ms = [((deadline - clock.call) * 1000).ceil, 1].max
          response = assessments.get(assessment_id: assessment_id, timeout_ms: remaining_ms)
          return response.result unless response.result.status == Models::Shared::Status::PENDING

          delay = retry_after(response.headers)
          raise WaitTimeoutError.new(assessment_id, response.result) if clock.call + delay > deadline

          sleeper.call(delay)
        end
      end

      private

      def retry_after(headers)
        value = headers.find { |name, _| name.to_s.casecmp?('retry-after') }&.last
        value = Array(value).first
        seconds = Float(value.to_s, exception: false)
        seconds.nil? ? 1.0 : [seconds, 1.0].max
      end
    end
  end

  # client.assessments.wait(assessment_id) reads the same as the generated methods.
  class Assessments
    def wait(assessment_id, **options)
      Wait.poll(self, assessment_id, **options)
    end
  end
end
