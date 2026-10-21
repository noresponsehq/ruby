# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Transport - Where the customer derived this context. Backend is the trusted integration path; browser values are treated as weak hints.
      class Transport < T::Enum
        enums do
          BACKEND = new("backend")
          BROWSER = new("browser")
        end
      end
    end
  end
end
