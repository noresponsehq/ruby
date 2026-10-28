# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AggregateDimension - decision, recommendation and band: the first answer's. flow: the assessment's. list_match: the action of the list entry that decided the account when it was first answered. reason: a reason the first answer fired, with its impact band. lane: an evidence lane the first answer listed in incomplete_sources. country and asn: the submitted IP's, from the IP data.
      class AggregateDimension
        include ::Crystalline::Enum
        enums do
          DECISION = new("decision")
          FLOW = new("flow")
          RECOMMENDATION = new("recommendation")
          BAND = new("band")
          REASON = new("reason")
          LANE = new("lane")
          COUNTRY = new("country")
          ASN = new("asn")
          LIST_MATCH = new("list_match")
        end

        open!
      end
    end
  end
end
