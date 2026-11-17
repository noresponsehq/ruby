# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class EnrichmentChangeKind < T::Enum
        enums do
          USERNAME = new("username")
          EMAIL = new("email")
          PHONE = new("phone")
        end
      end
    end
  end
end
