# ProfileMatchState

How sure the screening is that a profile is the person's, from the likelihood its record scores. Confirmed reaches the join bar of 0.9. Probable reaches 0.85, which takes a shared value beyond the one that found the account. Possible is the rest.

## Example Usage

```ruby
require "noresponse"

value = ProfileMatchState::CONFIRMED

# Open enum: use .deserialize() to create instances from custom string values
custom = ProfileMatchState.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `CONFIRMED` | confirmed   |
| `PROBABLE`  | probable    |
| `POSSIBLE`  | possible    |