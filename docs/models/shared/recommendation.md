# Recommendation

The recommended action: allow, step_up or review. Your application applies it.

## Example Usage

```ruby
require "noresponse"

value = Recommendation::ALLOW

# Open enum: use .deserialize() to create instances from custom string values
custom = Recommendation.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `ALLOW`   | allow     |
| `STEP_UP` | step_up   |
| `REVIEW`  | review    |