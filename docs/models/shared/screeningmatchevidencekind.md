# ScreeningMatchEvidenceKind

What matched. email, phone, supplied_handle and source_fact are hard identifiers; company, city and school are soft. supplied_handle is a handle on the person row; supplied_username is an account at the person's platform-free username, which alone makes a possible match; source_fact is an account a profile found by the person's lookups lists.

## Example Usage

```ruby
require "noresponse"

value = ScreeningMatchEvidenceKind::EMAIL

# Open enum: use .deserialize() to create instances from custom string values
custom = ScreeningMatchEvidenceKind.deserialize("custom_value")
```


## Values

| Name                | Value               |
| ------------------- | ------------------- |
| `EMAIL`             | email               |
| `PHONE`             | phone               |
| `SUPPLIED_HANDLE`   | supplied_handle     |
| `SUPPLIED_USERNAME` | supplied_username   |
| `SOURCE_FACT`       | source_fact         |
| `NAME`              | name                |
| `COMPANY`           | company             |
| `CITY`              | city                |
| `SCHOOL`            | school              |