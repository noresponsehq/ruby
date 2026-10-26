# Identifier

## Example Usage

```ruby
require "noresponse"

value = Identifier::EMAIL

# Open enum: use .deserialize() to create instances from custom string values
custom = Identifier.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `EMAIL`    | email      |
| `USERNAME` | username   |