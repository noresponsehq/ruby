# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ErrorCode - Why a failed search found nothing: its sources did not answer, none could be asked, or it could not run before its attempts were spent.
      class ErrorCode
        include ::Crystalline::Enum
        enums do
          NOT_ANSWERED = new("not_answered")
          NO_SOURCE = new("no_source")
          WORKER_ATTEMPTS_EXHAUSTED = new("worker_attempts_exhausted")
        end

        open!
      end
    end
  end
end
