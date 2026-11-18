# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # ScreeningMatchEvidenceKind - What matched. email, phone, supplied_handle and source_fact are hard identifiers; company, city and school are soft. supplied_handle is a handle on the person row; supplied_username is an account at the person's platform-free username, which alone makes a possible match; source_fact is an account a profile found by the person's lookups lists.
      class ScreeningMatchEvidenceKind
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          PHONE = new("phone")
          SUPPLIED_HANDLE = new("supplied_handle")
          SUPPLIED_USERNAME = new("supplied_username")
          SOURCE_FACT = new("source_fact")
          NAME = new("name")
          COMPANY = new("company")
          CITY = new("city")
          SCHOOL = new("school")
        end

        open!
      end
    end
  end
end
