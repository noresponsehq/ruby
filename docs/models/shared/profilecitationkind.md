# ProfileCitationKind

record: a record in lookup.records or profiles[].record. post: an item in posts. check: an item in lookup.checks.

## Example Usage

```ruby
require "noresponse"

value = ProfileCitationKind::RECORD

# Open enum: use .deserialize() to create instances from custom string values
custom = ProfileCitationKind.deserialize("custom_value")
```


## Values

| Name     | Value    |
| -------- | -------- |
| `RECORD` | record   |
| `POST`   | post     |
| `CHECK`  | check    |