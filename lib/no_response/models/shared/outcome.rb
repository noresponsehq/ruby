# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Outcome - What the provider later learned about the assessed account. confirmed_abuse, account_takeover and chargeback report abuse; false_positive and legitimate withdraw an earlier abuse report of this workspace for the assessment; unknown is recorded only. Outcomes are append-only and the latest one recorded for an assessment wins.
      class Outcome
        include ::Crystalline::Enum
        enums do
          CONFIRMED_ABUSE = new("confirmed_abuse")
          ACCOUNT_TAKEOVER = new("account_takeover")
          CHARGEBACK = new("chargeback")
          FALSE_POSITIVE = new("false_positive")
          LEGITIMATE = new("legitimate")
          UNKNOWN = new("unknown")
        end

        open!
      end
    end
  end
end
