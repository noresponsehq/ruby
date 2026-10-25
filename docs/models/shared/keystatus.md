# KeyStatus

active: the key authenticates. expired: a rotation's overlap window has ended (expires_at). revoked: the key was revoked (revoked_at) and answers 401.

## Example Usage

```ruby
require "noresponse"

value = KeyStatus::ACTIVE

# Open enum: use .deserialize() to create instances from custom string values
custom = KeyStatus.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `ACTIVE`  | active    |
| `EXPIRED` | expired   |
| `REVOKED` | revoked   |