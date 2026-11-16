# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # WrittenProfileErrorCode - Present only when status is failed. no_writer: no profile writer serves this environment. refused: the model refused. not_written: the answer was not a profile, or no statement survived grounding. uncited_statement: a statement or lead cited a record the person does not hold. not_answered: the writer did not answer. worker_attempts_exhausted: the worker stopped retrying.
      class WrittenProfileErrorCode
        include ::Crystalline::Enum
        enums do
          NO_WRITER = new("no_writer")
          REFUSED = new("refused")
          NOT_WRITTEN = new("not_written")
          UNCITED_STATEMENT = new("uncited_statement")
          NOT_ANSWERED = new("not_answered")
          WORKER_ATTEMPTS_EXHAUSTED = new("worker_attempts_exhausted")
        end

        open!
      end
    end
  end
end
