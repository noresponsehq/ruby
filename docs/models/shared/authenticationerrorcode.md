# AuthenticationErrorCode

Machine codes an HTTP 401 answer can carry.

## Example Usage

```ruby
require "noresponse"

value = AuthenticationErrorCode::UNAUTHORIZED

# Open enum: use .deserialize() to create instances from custom string values
custom = AuthenticationErrorCode.deserialize("custom_value")
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `UNAUTHORIZED` | unauthorized   |