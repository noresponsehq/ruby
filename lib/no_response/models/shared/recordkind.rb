# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # RecordKind - What sort of value a field holds, which decides how it is cleaned, compared and searched again. It comes from the value itself where its shape is certain (an email, an IP, a URL, an international phone number), else from the answer stored for the source's column, else text. A value of any kind is returned.
      class RecordKind
        include ::Crystalline::Enum
        enums do
          EMAIL = new("email")
          PHONE = new("phone")
          USERNAME = new("username")
          ACCOUNT_ID = new("account_id")
          URL = new("url")
          DOMAIN = new("domain")
          IMAGE = new("image")
          PERSON_NAME = new("person_name")
          GENDER = new("gender")
          AGE = new("age")
          LANGUAGE = new("language")
          ORGANISATION = new("organisation")
          JOB_TITLE = new("job_title")
          COUNTRY = new("country")
          REGION = new("region")
          CITY = new("city")
          ADDRESS = new("address")
          POSTCODE = new("postcode")
          COORDINATES = new("coordinates")
          TIMEZONE = new("timezone")
          DATE = new("date")
          DATE_TIME = new("date_time")
          DURATION = new("duration")
          IP = new("ip")
          MAC_ADDRESS = new("mac_address")
          DEVICE_ID = new("device_id")
          USER_AGENT = new("user_agent")
          PASSWORD = new("password")
          HASH = new("hash")
          SALT = new("salt")
          TOKEN = new("token")
          SECURITY_ANSWER = new("security_answer")
          CARD_NUMBER = new("card_number")
          BANK_ACCOUNT = new("bank_account")
          CRYPTO_ADDRESS = new("crypto_address")
          AMOUNT = new("amount")
          ID_NUMBER = new("id_number")
          VEHICLE = new("vehicle")
          LABEL = new("label")
          LONG_TEXT = new("long_text")
          COUNT = new("count")
          SCORE = new("score")
          FLAG = new("flag")
          STRUCTURED = new("structured")
          TEXT = new("text")
        end

        open!
      end
    end
  end
end
