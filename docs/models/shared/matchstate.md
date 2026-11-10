# MatchState

How sure the latest screening is that it found the attendee's accounts. unscreened until a screening reaches the attendee, and after one that had no profile to check (no_profile_to_check).

## Example Usage

```ruby
require "noresponse"

value = MatchState::UNSCREENED

# Open enum: use .deserialize() to create instances from custom string values
custom = MatchState.deserialize("custom_value")
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `UNSCREENED`   | unscreened     |
| `CONFIRMED`    | confirmed      |
| `PROBABLE`     | probable       |
| `POSSIBLE`     | possible       |
| `NONE_FOUND`   | none_found     |
| `INACCESSIBLE` | inaccessible   |