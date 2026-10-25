# OnExpiry

The decision a held assessment takes when hold_seconds pass before its investigation completes, unless the evidence so far gives a stricter one (default review). It is announced as account.risk_changed like any other change, so an expired hold is always announced. A hosted provider hook, which cannot wait, answers a held account by it at once: deny for block, allow otherwise. Kept while the flow is immediate.

## Example Usage

```ruby
require "noresponse"

value = OnExpiry::ALLOW

# Open enum: use .deserialize() to create instances from custom string values
custom = OnExpiry.deserialize("custom_value")
```


## Values

| Name     | Value    |
| -------- | -------- |
| `ALLOW`  | allow    |
| `REVIEW` | review   |
| `BLOCK`  | block    |