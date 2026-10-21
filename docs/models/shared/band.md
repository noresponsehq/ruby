# Band

low 0-29, medium 30-59, high 60-84, critical 85-100.

## Example Usage

```ruby
require "noresponse"

value = Band::LOW

# Open enum: use .deserialize() to create instances from custom string values
custom = Band.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `LOW`      | low        |
| `MEDIUM`   | medium     |
| `HIGH`     | high       |
| `CRITICAL` | critical   |