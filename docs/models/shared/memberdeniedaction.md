# MemberDeniedAction

## Example Usage

```ruby
require "noresponse"

value = MemberDeniedAction::EVIDENCE_READ

# Open enum: use .deserialize() to create instances from custom string values
custom = MemberDeniedAction.deserialize("custom_value")
```


## Values

| Name             | Value            |
| ---------------- | ---------------- |
| `EVIDENCE_READ`  | evidence.read    |
| `EXPORTS_READ`   | exports.read     |
| `POLICY_PUBLISH` | policy.publish   |