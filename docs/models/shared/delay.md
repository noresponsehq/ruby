# Delay

How long after the assessment's creation the change was made.

## Example Usage

```ruby
require "noresponse"

value = Delay::UNDER_10S

# Open enum: use .deserialize() to create instances from custom string values
custom = Delay.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `UNDER_10S` | under_10s   |
| `UNDER_1M`  | under_1m    |
| `UNDER_10M` | under_10m   |
| `UNDER_1H`  | under_1h    |
| `UNDER_1D`  | under_1d    |
| `OVER_1D`   | over_1d     |