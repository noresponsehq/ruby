# ConflictErrorCode

Machine codes an HTTP 409 answer can carry.

## Example Usage

```ruby
require "noresponse"

value = ConflictErrorCode::IDEMPOTENCY_KEY_REUSED

# Open enum: use .deserialize() to create instances from custom string values
custom = ConflictErrorCode.deserialize("custom_value")
```


## Values

| Name                       | Value                      |
| -------------------------- | -------------------------- |
| `IDEMPOTENCY_KEY_REUSED`   | idempotency_key_reused     |
| `KEY_ROTATION_IN_PROGRESS` | key_rotation_in_progress   |