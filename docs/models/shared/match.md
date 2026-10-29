# Match

exact compares the original submitted value; canonical uses identifier-specific normalisation; mailbox explicitly selects the email alias rules used by lists.

## Example Usage

```ruby
require "noresponse"

value = Match::EXACT

# Open enum: use .deserialize() to create instances from custom string values
custom = Match.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `EXACT`     | exact       |
| `CANONICAL` | canonical   |
| `MAILBOX`   | mailbox     |