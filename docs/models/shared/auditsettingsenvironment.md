# AuditSettingsEnvironment

## Example Usage

```ruby
require "noresponse"

value = AuditSettingsEnvironment::LIVE

# Open enum: use .deserialize() to create instances from custom string values
custom = AuditSettingsEnvironment.deserialize("custom_value")
```


## Values

| Name   | Value  |
| ------ | ------ |
| `LIVE` | live   |
| `TEST` | test   |