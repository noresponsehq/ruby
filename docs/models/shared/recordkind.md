# RecordKind

What sort of value a field holds, which decides how it is cleaned, compared and searched again. It comes from the value itself where its shape is certain (an email, an IP, a URL, an international phone number), else from the answer stored for the source's column, else text. A value of any kind is returned. Each kind's description says what it holds and the form value takes.

## Example Usage

```ruby
require "noresponse"

value = RecordKind::EMAIL

# Open enum: use .deserialize() to create instances from custom string values
custom = RecordKind.deserialize("custom_value")
```


## Values

| Name              | Value             |
| ----------------- | ----------------- |
| `EMAIL`           | email             |
| `PHONE`           | phone             |
| `USERNAME`        | username          |
| `ACCOUNT_ID`      | account_id        |
| `URL`             | url               |
| `DOMAIN`          | domain            |
| `IMAGE`           | image             |
| `PERSON_NAME`     | person_name       |
| `GENDER`          | gender            |
| `AGE`             | age               |
| `LANGUAGE`        | language          |
| `ORGANISATION`    | organisation      |
| `JOB_TITLE`       | job_title         |
| `COUNTRY`         | country           |
| `REGION`          | region            |
| `CITY`            | city              |
| `ADDRESS`         | address           |
| `POSTCODE`        | postcode          |
| `COORDINATES`     | coordinates       |
| `TIMEZONE`        | timezone          |
| `DATE`            | date              |
| `DATE_TIME`       | date_time         |
| `DURATION`        | duration          |
| `IP`              | ip                |
| `MAC_ADDRESS`     | mac_address       |
| `DEVICE_ID`       | device_id         |
| `USER_AGENT`      | user_agent        |
| `PASSWORD`        | password          |
| `HASH`            | hash              |
| `SALT`            | salt              |
| `TOKEN`           | token             |
| `SECURITY_ANSWER` | security_answer   |
| `CARD_NUMBER`     | card_number       |
| `BANK_ACCOUNT`    | bank_account      |
| `CRYPTO_ADDRESS`  | crypto_address    |
| `AMOUNT`          | amount            |
| `ID_NUMBER`       | id_number         |
| `VEHICLE`         | vehicle           |
| `LABEL`           | label             |
| `LONG_TEXT`       | long_text         |
| `COUNT`           | count             |
| `SCORE`           | score             |
| `FLAG`            | flag              |
| `STRUCTURED`      | structured        |
| `TEXT`            | text              |