# BadRequestErrorCode

Machine codes an HTTP 400 answer can carry.

## Example Usage

```ruby
require "noresponse"

value = BadRequestErrorCode::INVALID_REQUEST

# Open enum: use .deserialize() to create instances from custom string values
custom = BadRequestErrorCode.deserialize("custom_value")
```


## Values

| Name                      | Value                     |
| ------------------------- | ------------------------- |
| `INVALID_REQUEST`         | invalid_request           |
| `INVALID_IDEMPOTENCY_KEY` | invalid_idempotency_key   |
| `INVALID_CURSOR`          | invalid_cursor            |