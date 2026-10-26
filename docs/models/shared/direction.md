# Direction

## Example Usage

```ruby
require "noresponse"

value = Direction::RAISES

# Open enum: use .deserialize() to create instances from custom string values
custom = Direction.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `RAISES`  | raises    |
| `LOWERS`  | lowers    |
| `NEUTRAL` | neutral   |