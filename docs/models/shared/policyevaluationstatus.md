# PolicyEvaluationStatus

## Example Usage

```ruby
require "noresponse"

value = PolicyEvaluationStatus::QUEUED

# Open enum: use .deserialize() to create instances from custom string values
custom = PolicyEvaluationStatus.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `QUEUED`    | queued      |
| `RUNNING`   | running     |
| `COMPLETED` | completed   |
| `FAILED`    | failed      |
| `CANCELLED` | cancelled   |