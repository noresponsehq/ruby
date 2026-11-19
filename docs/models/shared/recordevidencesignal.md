# RecordEvidenceSignal

found_by: what found the record, which sets where its likelihood starts. agrees: a value the record shares with what the investigator gave or with a joined record. clashes: a birth date, full name, gender or country that differs from theirs.

## Example Usage

```ruby
require "noresponse"

value = RecordEvidenceSignal::FOUND_BY

# Open enum: use .deserialize() to create instances from custom string values
custom = RecordEvidenceSignal.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `FOUND_BY` | found_by   |
| `AGREES`   | agrees     |
| `CLASHES`  | clashes    |