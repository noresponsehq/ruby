# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AnswerRevision - Which answer of each assessment the filters describe: latest, the latest stored revision, or first, the first answer, as served when the assessment was first answered (POST /v1/assessments/aggregate counts first answers). A cell of an aggregate drills down to POST /v1/assessments/search with the same filters, revision first and the cell's bucket as from and to.
      class AnswerRevision < T::Enum
        enums do
          LATEST = new("latest")
          FIRST = new("first")
        end
      end
    end
  end
end
