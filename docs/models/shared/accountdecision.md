# AccountDecision

block when the score reached your block threshold (risk.block of the assessment), otherwise the assessment's recommendation. Your application applies it.

## Example Usage

```ruby
require "noresponse"

value = AccountDecision::ALLOW

# Open enum: use .deserialize() to create instances from custom string values
custom = AccountDecision.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `ALLOW`   | allow     |
| `STEP_UP` | step_up   |
| `REVIEW`  | review    |
| `BLOCK`   | block     |