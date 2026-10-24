# EnforcementStatus

applied when the identity provider accepted the action, failed when it refused it or could not be reached. Only applied counts as enforced.

## Example Usage

```ruby
require "noresponse"

value = EnforcementStatus::APPLIED

# Open enum: use .deserialize() to create instances from custom string values
custom = EnforcementStatus.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `APPLIED` | applied   |
| `FAILED`  | failed    |