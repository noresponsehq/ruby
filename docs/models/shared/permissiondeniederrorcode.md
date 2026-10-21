# PermissionDeniedErrorCode

Machine codes an HTTP 403 answer can carry.

## Example Usage

```ruby
require "noresponse"

value = PermissionDeniedErrorCode::TENANT_FORBIDDEN

# Open enum: use .deserialize() to create instances from custom string values
custom = PermissionDeniedErrorCode.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `TENANT_FORBIDDEN` | tenant_forbidden   |