# ProfileMatchState

How sure the screening is that a profile is the attendee's, from its evidence: confirmed is a handle on the attendee row, or two or more hard identifiers (email, phone, a supplied handle, or a fact an existing source returned); probable is one identifier beyond the name; possible is the name alone.

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