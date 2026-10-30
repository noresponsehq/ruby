# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ScopeEnum - assessment requires one submission to satisfy the complete expression. account permits witnesses across retained submissions of one account and is supported only by POST /v1/accounts/search. No default: select scope explicitly.
      class ScopeEnum < T::Enum
        enums do
          ASSESSMENT = new("assessment")
          ACCOUNT = new("account")
        end
      end
    end
  end
end
