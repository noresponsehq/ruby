# PermissionDeniedErrorCode

Machine codes an HTTP 403 answer can carry.

## Example Usage

```ruby
require "noresponse"

value = PermissionDeniedErrorCode::WORKSPACE_FORBIDDEN

# Open enum: use .deserialize() to create instances from custom string values
custom = PermissionDeniedErrorCode.deserialize("custom_value")
```


## Values

| Name                  | Value                 |
| --------------------- | --------------------- |
| `WORKSPACE_FORBIDDEN` | workspace_forbidden   |
| `ROLE_FORBIDDEN`      | role_forbidden        |