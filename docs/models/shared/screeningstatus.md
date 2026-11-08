# ScreeningStatus

partial finished with some attendees not covered; attendees_failed counts them.

## Example Usage

```ruby
require "noresponse"

value = ScreeningStatus::QUEUED

# Open enum: use .deserialize() to create instances from custom string values
custom = ScreeningStatus.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `QUEUED`    | queued      |
| `RUNNING`   | running     |
| `COMPLETED` | completed   |
| `PARTIAL`   | partial     |
| `FAILED`    | failed      |
| `CANCELLED` | cancelled   |