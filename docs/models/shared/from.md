# From

## Example Usage

```ruby
require "noresponse"

value = From::ALLOW

# Open enum: use .deserialize() to create instances from custom string values
custom = From.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `ALLOW`   | allow     |
| `STEP_UP` | step_up   |
| `REVIEW`  | review    |
| `BLOCK`   | block     |
| `HELD`    | held      |