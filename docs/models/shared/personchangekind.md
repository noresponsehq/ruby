# PersonChangeKind

account_added and account_removed: an account or profile appeared or disappeared. breach_added and breach_removed: a breach record appeared or disappeared. identifier_added and identifier_removed: an email, phone, username, name or account id on an account the person already held. field_changed: another field on such an account. posts_added: new posts, counted in count.

## Example Usage

```ruby
require "noresponse"

value = PersonChangeKind::ACCOUNT_ADDED

# Open enum: use .deserialize() to create instances from custom string values
custom = PersonChangeKind.deserialize("custom_value")
```


## Values

| Name                 | Value                |
| -------------------- | -------------------- |
| `ACCOUNT_ADDED`      | account_added        |
| `ACCOUNT_REMOVED`    | account_removed      |
| `BREACH_ADDED`       | breach_added         |
| `BREACH_REMOVED`     | breach_removed       |
| `IDENTIFIER_ADDED`   | identifier_added     |
| `IDENTIFIER_REMOVED` | identifier_removed   |
| `FIELD_CHANGED`      | field_changed        |
| `POSTS_ADDED`        | posts_added          |