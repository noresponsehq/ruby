# Status

Processing state, separate from evidence coverage. complete: final; nothing is still running, but unsupported, failed or unanswered lanes remain in incomplete_sources. partial: a recommendation exists and evidence is incomplete; assessment_url identifies continuing work when present. pending: no recommendation yet; poll or wait for the webhook. Finished processing does not mean all sources answered.

## Example Usage

```ruby
require "noresponse"

value = Status::COMPLETE

# Open enum: use .deserialize() to create instances from custom string values
custom = Status.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `COMPLETE` | complete   |
| `PARTIAL`  | partial    |
| `PENDING`  | pending    |