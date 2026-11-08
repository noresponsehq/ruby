# AttendeeDecision

## Example Usage

```ruby
require "noresponse"

value = AttendeeDecision::CLEARED

# Open enum: use .deserialize() to create instances from custom string values
custom = AttendeeDecision.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `CLEARED`   | cleared     |
| `WATCH`     | watch       |
| `ESCALATED` | escalated   |