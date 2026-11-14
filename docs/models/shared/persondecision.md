# PersonDecision

## Example Usage

```ruby
require "noresponse"

value = PersonDecision::CLEARED

# Open enum: use .deserialize() to create instances from custom string values
custom = PersonDecision.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `CLEARED`   | cleared     |
| `WATCH`     | watch       |
| `ESCALATED` | escalated   |