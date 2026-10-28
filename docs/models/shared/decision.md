# Decision

An assessment's own decision: block when its stored risk.block is true, otherwise its recommendation. It is not the account's decision or held-admission state.

## Example Usage

```ruby
require "noresponse"

value = Decision::ALLOW

# Open enum: use .deserialize() to create instances from custom string values
custom = Decision.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `ALLOW`   | allow     |
| `STEP_UP` | step_up   |
| `REVIEW`  | review    |
| `BLOCK`   | block     |