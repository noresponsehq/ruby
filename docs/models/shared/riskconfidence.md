# RiskConfidence

How much of the planned evidence answered; it says nothing about risk.

## Example Usage

```ruby
require "noresponse"

value = RiskConfidence::LOW

# Open enum: use .deserialize() to create instances from custom string values
custom = RiskConfidence.deserialize("custom_value")
```


## Values

| Name     | Value    |
| -------- | -------- |
| `LOW`    | low      |
| `MEDIUM` | medium   |
| `HIGH`   | high     |