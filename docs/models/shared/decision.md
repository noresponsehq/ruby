# Decision

The decision of the assessment's latest stored revision: block when its stored risk.block is true, otherwise its recommendation. This is not the account's current decision or held-admission state. Combined with recommendation using AND.

## Example Usage

```ruby
require "noresponse"

value = Decision::ALLOW
```


## Values

| Name      | Value     |
| --------- | --------- |
| `ALLOW`   | allow     |
| `STEP_UP` | step_up   |
| `REVIEW`  | review    |
| `BLOCK`   | block     |