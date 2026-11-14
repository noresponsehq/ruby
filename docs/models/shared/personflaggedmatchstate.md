# PersonFlaggedMatchState

How sure the screening is that the accounts it read are the person's. A finding on a possible match is at most moderate, on a probable match at most high.

## Example Usage

```ruby
require "noresponse"

value = PersonFlaggedMatchState::CONFIRMED
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `CONFIRMED`    | confirmed      |
| `PROBABLE`     | probable       |
| `POSSIBLE`     | possible       |
| `NONE_FOUND`   | none_found     |
| `INACCESSIBLE` | inaccessible   |