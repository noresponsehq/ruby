# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # Attribute - name_gender is the records' gender against the submitted first name's usual one.
      class Attribute
        include ::Crystalline::Enum
        enums do
          BIRTH_DATE = new("birth_date")
          GENDER = new("gender")
          NATIONALITY = new("nationality")
          NAME_GENDER = new("name_gender")
        end

        open!
      end
    end
  end
end
