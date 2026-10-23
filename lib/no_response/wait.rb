# typed: true
# frozen_string_literal: true

# Wait for an assessment to complete. Hand-written beside the generated client.

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

      # Poll client.assessments.get until the assessment's status is complete,
      # sleeping for the Retry-After the API sends (at least 1 s) between
      # polls. Once timeout seconds have passed it returns a partial answer as
      # it stands, its status still PARTIAL, and raises WaitTimeoutError if the
      # assessment is still pending. A poll cut off by the deadline also
      # returns the last partial answer instead of losing it.
      def wait(client, assessment_id, **options)
        poll(client.assessments, assessment_id, **options)
      end

      def poll(assessments, assessment_id, timeout: DEFAULT_TIMEOUT_SECONDS, sleeper: Kernel.method(:sleep),
               clock: -> { Process.clock_gettime(Process::CLOCK_MONOTONIC) })
        raise ArgumentError, 'timeout must be positive' unless timeout.positive?

        deadline = clock.call + timeout
        last = T.let(nil, T.untyped)
        loop do
          remaining_ms = [((deadline - clock.call) * 1000).ceil, 1].max
          begin
            response = assessments.get(assessment_id: assessment_id, timeout_ms: remaining_ms)
          rescue Faraday::TimeoutError
            # Each poll is bounded by the time left, so a request timeout here
            # is the wait running out: a partial answer from an earlier poll
            # stands. Anything else, or a timeout before the deadline, raises.
            raise unless clock.call >= deadline && last&.status == Models::Shared::Status::PARTIAL

            return last
          end
          last = response.result
          status = response.result.status
          return response.result if status == Models::Shared::Status::COMPLETE

          delay = retry_after(response.headers)
          if clock.call + delay > deadline
            return response.result if status == Models::Shared::Status::PARTIAL

            raise WaitTimeoutError.new(assessment_id, response.result)
          end

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
