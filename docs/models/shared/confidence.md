# Confidence

Ordinal confidence in the recommendation under the current policy: low, medium, high or unavailable.

## Example Usage

```ruby
require "noresponse"

value = Confidence::LOW

# Open enum: use .deserialize() to create instances from custom string values
custom = Confidence.deserialize("custom_value")
```


## Values

| Name          | Value         |
| ------------- | ------------- |
| `LOW`         | low           |
| `MEDIUM`      | medium        |
| `HIGH`        | high          |
| `UNAVAILABLE` | unavailable   |