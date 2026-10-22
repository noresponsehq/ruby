# HookPoint

The provider event a provider_hook context was sent for. pre_registration runs before the user exists, so subject and the request's account_id may be absent there. Sent only with transport provider_hook.

## Example Usage

```ruby
require "noresponse"

value = HookPoint::PRE_REGISTRATION
```


## Values

| Name                | Value               |
| ------------------- | ------------------- |
| `PRE_REGISTRATION`  | pre_registration    |
| `POST_REGISTRATION` | post_registration   |
| `PRE_LOGIN`         | pre_login           |
| `POST_LOGIN`        | post_login          |
| `TOKEN_ISSUANCE`    | token_issuance      |