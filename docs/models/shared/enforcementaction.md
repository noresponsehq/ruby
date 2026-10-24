# EnforcementAction

What the workspace did in its identity provider: revoke_sessions (signed the account out everywhere), restrict (limited what the account can do), unrestrict (lifted an earlier restriction), fail_onboarding (stopped an account that was still onboarding), reject_activation (refused to activate a provisional account) or none (decided to take no action).

## Example Usage

```ruby
require "noresponse"

value = EnforcementAction::REVOKE_SESSIONS

# Open enum: use .deserialize() to create instances from custom string values
custom = EnforcementAction.deserialize("custom_value")
```


## Values

| Name                | Value               |
| ------------------- | ------------------- |
| `REVOKE_SESSIONS`   | revoke_sessions     |
| `RESTRICT`          | restrict            |
| `UNRESTRICT`        | unrestrict          |
| `FAIL_ONBOARDING`   | fail_onboarding     |
| `REJECT_ACTIVATION` | reject_activation   |
| `NONE`              | none                |