# EnforcementProvider

The identity provider the action ran in; custom for the workspace's own user store.

## Example Usage

```ruby
require "noresponse"

value = EnforcementProvider::CLERK

# Open enum: use .deserialize() to create instances from custom string values
custom = EnforcementProvider.deserialize("custom_value")
```


## Values

| Name     | Value    |
| -------- | -------- |
| `CLERK`  | clerk    |
| `WORKOS` | workos   |
| `AUTH0`  | auth0    |
| `CUSTOM` | custom   |