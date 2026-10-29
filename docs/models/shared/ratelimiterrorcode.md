# RateLimitErrorCode

Machine codes an HTTP 429 answer can carry.

## Example Usage

```ruby
require "noresponse"

value = RateLimitErrorCode::RATE_LIMITED

# Open enum: use .deserialize() to create instances from custom string values
custom = RateLimitErrorCode.deserialize("custom_value")
```


## Values

| Name                          | Value                         |
| ----------------------------- | ----------------------------- |
| `RATE_LIMITED`                | rate_limited                  |
| `ASSESSMENT_BUDGET_EXHAUSTED` | assessment_budget_exhausted   |
| `EXPORT_LIMIT_REACHED`        | export_limit_reached          |