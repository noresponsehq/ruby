# InvestigationStatus

## Example Usage

```ruby
require "noresponse"

value = InvestigationStatus::QUEUED

# Open enum: use .deserialize() to create instances from custom string values
custom = InvestigationStatus.deserialize("custom_value")
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
| `UNKNOWN`   | unknown     |