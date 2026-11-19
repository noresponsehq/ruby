# Significance

One rule ranks every change: identity changes (accounts, breaches, identifiers) are high, profile fields and findings are medium, new posts are low.

## Example Usage

```ruby
require "noresponse"

value = Significance::HIGH

# Open enum: use .deserialize() to create instances from custom string values
custom = Significance.deserialize("custom_value")
```


## Values

| Name     | Value    |
| -------- | -------- |
| `HIGH`   | high     |
| `MEDIUM` | medium   |
| `LOW`    | low      |