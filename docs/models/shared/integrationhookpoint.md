# IntegrationHookPoint

pre_registration runs before the user exists; post_login runs after a successful sign-in.

## Example Usage

```ruby
require "noresponse"

value = IntegrationHookPoint::PRE_REGISTRATION

# Open enum: use .deserialize() to create instances from custom string values
custom = IntegrationHookPoint.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `PRE_REGISTRATION` | pre_registration   |
| `POST_LOGIN`       | post_login         |