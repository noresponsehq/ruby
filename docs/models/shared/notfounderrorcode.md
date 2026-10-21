# NotFoundErrorCode

Machine codes an HTTP 404 answer can carry.

## Example Usage

```ruby
require "noresponse"

value = NotFoundErrorCode::NOT_FOUND

# Open enum: use .deserialize() to create instances from custom string values
custom = NotFoundErrorCode.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `NOT_FOUND` | not_found   |