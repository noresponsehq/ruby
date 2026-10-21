# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # AssuranceLevel - Provider or OIDC assurance level, when the customer has mapped one.
      class AssuranceLevel < T::Enum
        enums do
          UNKNOWN = new("unknown")
          LOW = new("low")
          MEDIUM = new("medium")
          HIGH = new("high")
        end
      end
    end
  end
end
