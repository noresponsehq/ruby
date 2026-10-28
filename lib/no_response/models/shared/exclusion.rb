# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class Exclusion
        include ::Crystalline::Enum
        enums do
          EXPIRED_OR_ERASED_RECORDS = new("expired_or_erased_records")
          SECRETS_AND_CREDENTIAL_DIGESTS = new("secrets_and_credential_digests")
          PRIVATE_SOURCE_AND_WORK_PAYLOADS = new("private_source_and_work_payloads")
          CROSS_CUSTOMER_DATA = new("cross_customer_data")
          LEGACY_OUTCOME_NOTES = new("legacy_outcome_notes")
          UNCAPTURED_HISTORICAL_DECISIONS = new("uncaptured_historical_decisions")
        end

        open!
      end
    end
  end
end
