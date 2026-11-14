# typed: true
# frozen_string_literal: true

module NoResponse
  module Models
    module Shared
      # RecordKind - What sort of value a field holds, which decides how it is cleaned, compared and searched again. It comes from the value itself where its shape is certain (an email, an IP, a URL, an international phone number), else from the answer stored for the source's column, else text. A value of any kind is returned. Each kind's description says what it holds and the form value takes.
      class RecordKind
        include ::Crystalline::Enum
        enums do
          # An email address. value: in lower case, without a mailto: prefix.
          EMAIL = new("email")
          # A phone number. value: in E.164 form, such as +447700900123. A national number is cleaned only when the country of the source's site is known.
          PHONE = new("phone")
          # A handle a person chose. value: as written. Compare it in lower case.
          USERNAME = new("username")
          # A platform's own id for an account. value: as written.
          ACCOUNT_ID = new("account_id")
          # A web address. value: the scheme and host in lower case, the path, query and fragment as written.
          URL = new("url")
          # A host name with no path. value: in lower case, also when the source wrote a URL.
          DOMAIN = new("domain")
          # A picture, as a link or a file. value: the link, cleaned as a `url`.
          IMAGE = new("image")
          # A whole name or a part of one. value: with each run of spaces made one space.
          PERSON_NAME = new("person_name")
          # A stated gender. value: `female`, `male` or `other` when the value names one of them, else as written.
          GENDER = new("gender")
          # An age in years. value: a whole number from 0 to 150.
          AGE = new("age")
          # A language. value: its ISO 639 code, two letters when the language has them.
          LANGUAGE = new("language")
          # A company, school or group by name. value: with each run of spaces made one space.
          ORGANISATION = new("organisation")
          # A position or occupation. value: as written.
          JOB_TITLE = new("job_title")
          # A country. value: its ISO 3166-1 alpha-2 code, such as GB.
          COUNTRY = new("country")
          # A state, province or county. value: as written.
          REGION = new("region")
          # A city or town. value: as written.
          CITY = new("city")
          # A street address or one line of it. value: as written.
          ADDRESS = new("address")
          # A postal code. value: in upper case with single spaces.
          POSTCODE = new("postcode")
          # A latitude and longitude. value: `latitude,longitude` in decimal degrees.
          COORDINATES = new("coordinates")
          # A timezone or an offset. value: an IANA zone name, UTC, or an offset such as +05:30.
          TIMEZONE = new("timezone")
          # A calendar date. value: in ISO form at the precision the source gives: 2014, 2014-03 or 2014-03-07.
          DATE = new("date")
          # A moment. value: in ISO form in UTC, such as 2014-03-07T09:30:00Z, or a date when the source gives no time.
          DATE_TIME = new("date_time")
          # A length of time. value: a number of seconds.
          DURATION = new("duration")
          # An IPv4 or IPv6 address. value: its standard text form. An IPv4 address stored as a whole number is written as IPv4.
          IP = new("ip")
          # A network card address. value: in lower case with colons.
          MAC_ADDRESS = new("mac_address")
          # An id of a phone, computer or browser. value: as written.
          DEVICE_ID = new("device_id")
          # A browser or app signature. value: as written.
          USER_AGENT = new("user_agent")
          # A password in plain text. value: exactly as written, spaces included.
          PASSWORD = new("password")
          # A password hash. value: as written. detail names the likely algorithm, such as bcrypt.
          HASH = new("hash")
          # The salt for a hash. value: exactly as written.
          SALT = new("salt")
          # A session, reset or API token. value: as written.
          TOKEN = new("token")
          # A security question or its answer. value: exactly as written.
          SECURITY_ANSWER = new("security_answer")
          # A payment card number. value: its 12 to 19 digits only.
          CARD_NUMBER = new("card_number")
          # An IBAN or account number. value: its letters and digits only, in upper case.
          BANK_ACCOUNT = new("bank_account")
          # A wallet address. value: as written. detail names the likely coin, such as BTC.
          CRYPTO_ADDRESS = new("crypto_address")
          # Money, with its currency when given. value: a plain decimal. detail names the currency, such as USD.
          AMOUNT = new("amount")
          # A passport, tax, national or licence number. value: as written.
          ID_NUMBER = new("id_number")
          # A number plate or a VIN. value: in upper case with no spaces.
          VEHICLE = new("vehicle")
          # One of a small set, such as a status or level. value: as written.
          LABEL = new("label")
          # Free writing, such as a bio or signature. value: as written.
          LONG_TEXT = new("long_text")
          # A whole number of things. value: a whole number with no thousands separators.
          COUNT = new("count")
          # A rating, rank or points. value: a plain decimal.
          SCORE = new("score")
          # A yes or no. value: `true` or `false`.
          FLAG = new("flag")
          # A nested value that could not be split. value: as written.
          STRUCTURED = new("structured")
          # Anything else. value: as written.
          TEXT = new("text")
        end

        open!
      end
    end
  end
end
