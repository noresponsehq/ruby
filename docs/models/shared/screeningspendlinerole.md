# ScreeningSpendLineRole

What the implementation did. analyser appears only on spend recorded before the engine stopped analysing posts.

## Example Usage

```ruby
require "noresponse"

value = ScreeningSpendLineRole::RESOLVER

# Open enum: use .deserialize() to create instances from custom string values
custom = ScreeningSpendLineRole.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `RESOLVER`  | resolver    |
| `COLLECTOR` | collector   |
| `ANALYSER`  | analyser    |