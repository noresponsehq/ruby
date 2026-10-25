# IntegrationPlatform

The authentication provider that calls the endpoint.

## Example Usage

```ruby
require "noresponse"

value = IntegrationPlatform::WORKOS

# Open enum: use .deserialize() to create instances from custom string values
custom = IntegrationPlatform.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `WORKOS`   | workos     |
| `AUTH0`    | auth0      |
| `SUPABASE` | supabase   |