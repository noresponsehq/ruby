# FindingBand

How severe a finding is, most severe first.

## Example Usage

```ruby
require "noresponse"

value = FindingBand::CRITICAL

# Open enum: use .deserialize() to create instances from custom string values
custom = FindingBand.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `CRITICAL` | critical   |
| `HIGH`     | high       |
| `MODERATE` | moderate   |
| `LOW`      | low        |
| `INFO`     | info       |