# SignIn

## Example Usage

```ruby
require "noresponse"

value = SignIn::PASSWORD

# Open enum: use .deserialize() to create instances from custom string values
custom = SignIn.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `PASSWORD`  | password    |
| `GOOGLE`    | google      |
| `FACEBOOK`  | facebook    |
| `APPLE`     | apple       |
| `MICROSOFT` | microsoft   |
| `SSO`       | sso         |
| `OTHER`     | other       |