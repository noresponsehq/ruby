# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared

      class ReviewSubjectKind
        include ::Crystalline::Enum
        enums do
          ACCOUNT = new("account")
          ASSESSMENT = new("assessment")
          ISSUED_CREDENTIAL = new("issued_credential")
        end

        open!
      end
    end
  end
end
