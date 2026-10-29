# Action

## Example Usage

```ruby
require "noresponse"

value = Action::ALLOW

# Open enum: use .deserialize() to create instances from custom string values
custom = Action.deserialize("custom_value")
```


## Values

| Name    | Value   |
| ------- | ------- |
| `ALLOW` | allow   |
| `BLOCK` | block   |