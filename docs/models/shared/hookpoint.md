# HookPoint

The provider event a provider_hook context was sent for; absent for any other transport.

## Example Usage

```ruby
require "noresponse"

value = HookPoint::PRE_REGISTRATION

# Open enum: use .deserialize() to create instances from custom string values
custom = HookPoint.deserialize("custom_value")
```


## Values

| Name                | Value               |
| ------------------- | ------------------- |
| `PRE_REGISTRATION`  | pre_registration    |
| `POST_REGISTRATION` | post_registration   |
| `PRE_LOGIN`         | pre_login           |
| `POST_LOGIN`        | post_login          |
| `TOKEN_ISSUANCE`    | token_issuance      |