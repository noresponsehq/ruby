# Priority

## Example Usage

```ruby
require "noresponse"

value = Priority::LOW

# Open enum: use .deserialize() to create instances from custom string values
custom = Priority.deserialize("custom_value")
```


## Values

| Name     | Value    |
| -------- | -------- |
| `LOW`    | low      |
| `NORMAL` | normal   |
| `HIGH`   | high     |
| `URGENT` | urgent   |