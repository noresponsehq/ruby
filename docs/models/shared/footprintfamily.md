# FootprintFamily

The source-neutral kind of evidence: account_presence (an account found on a site), auth_provider (the account at your auth provider), breach (breach and credential tables), breach_abuse (abuse and fraud communities' tables) and code_hosting (a code hosting profile).

## Example Usage

```ruby
require "noresponse"

value = FootprintFamily::ACCOUNT_PRESENCE

# Open enum: use .deserialize() to create instances from custom string values
custom = FootprintFamily.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `ACCOUNT_PRESENCE` | account_presence   |
| `AUTH_PROVIDER`    | auth_provider      |
| `BREACH`           | breach             |
| `BREACH_ABUSE`     | breach_abuse       |
| `CODE_HOSTING`     | code_hosting       |