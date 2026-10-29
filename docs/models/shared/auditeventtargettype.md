# AuditEventTargetType

The kind of resource the change acted on.

## Example Usage

```ruby
require "noresponse"

value = AuditEventTargetType::WORKSPACE

# Open enum: use .deserialize() to create instances from custom string values
custom = AuditEventTargetType.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `WORKSPACE`        | workspace          |
| `MEMBER`           | member             |
| `INVITE`           | invite             |
| `KEY`              | key                |
| `SETTING`          | setting            |
| `WEBHOOK_ENDPOINT` | webhook_endpoint   |
| `INTEGRATION`      | integration        |
| `BILLING`          | billing            |
| `REVIEW`           | review             |