# Impact

## Example Usage

```ruby
require "noresponse"

value = Impact::NONE

# Open enum: use .deserialize() to create instances from custom string values
custom = Impact.deserialize("custom_value")
```


## Values

| Name     | Value    |
| -------- | -------- |
| `NONE`   | none     |
| `LOW`    | low      |
| `MEDIUM` | medium   |
| `HIGH`   | high     |