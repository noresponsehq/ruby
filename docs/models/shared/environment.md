# Environment

## Example Usage

```ruby
require "noresponse"

value = Environment::LIVE

# Open enum: use .deserialize() to create instances from custom string values
custom = Environment.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `LIVE`      | live        |
| `TEST`      | test        |
| `WORKSPACE` | workspace   |