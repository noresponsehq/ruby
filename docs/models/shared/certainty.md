# Certainty

confirmed: a linked record or the searched identifier states it directly. likely: a strong inference. possible: a weak inference.

## Example Usage

```ruby
require "noresponse"

value = Certainty::CONFIRMED

# Open enum: use .deserialize() to create instances from custom string values
custom = Certainty.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `CONFIRMED` | confirmed   |
| `LIKELY`    | likely      |
| `POSSIBLE`  | possible    |