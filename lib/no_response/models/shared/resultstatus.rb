# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ResultStatus
        include ::Crystalline::Enum
        enums do
          NO_CHANGE = new("no_change")
          PROPOSAL_REQUIRES_REVIEW = new("proposal_requires_review")
        end

        open!
      end
    end
  end
end
