# EnforcementState

The account's state in the workspace's identity provider just before the action: onboarding, provisional (created, not yet activated), active, restricted or rejected.

## Example Usage

```ruby
require "noresponse"

value = EnforcementState::ONBOARDING

# Open enum: use .deserialize() to create instances from custom string values
custom = EnforcementState.deserialize("custom_value")
```


## Values

| Name          | Value         |
| ------------- | ------------- |
| `ONBOARDING`  | onboarding    |
| `PROVISIONAL` | provisional   |
| `ACTIVE`      | active        |
| `RESTRICTED`  | restricted    |
| `REJECTED`    | rejected      |