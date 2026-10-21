# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ResponseMode - standard returns the consolidated risk response; detailed adds merged provider-neutral facts when the key has detailed scope. There is no raw mode.
      class ResponseMode < T::Enum
        enums do
          STANDARD = new("standard")
          DETAILED = new("detailed")
        end
      end
    end
  end
end
