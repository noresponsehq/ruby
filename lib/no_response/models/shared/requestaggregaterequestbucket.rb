# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class RequestAggregateRequestBucket
        include ::Crystalline::Enum
        enums do
          HOUR = new("hour")
          DAY = new("day")
        end

        open!
      end
    end
  end
end
