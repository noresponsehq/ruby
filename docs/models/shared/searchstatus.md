# SearchStatus

A password or hash search is counting, then counted: rows says how many breach rows hold the value, and nothing runs until a person runs it (POST .../searches/{search_id}/run). Any other search is queued, then running. completed: every source it asked answered. partial: some did not. failed: none answered or none could be asked, which says nothing about whether the value is held anywhere.

## Example Usage

```ruby
require "noresponse"

value = SearchStatus::COUNTING

# Open enum: use .deserialize() to create instances from custom string values
custom = SearchStatus.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `COUNTING`  | counting    |
| `COUNTED`   | counted     |
| `QUEUED`    | queued      |
| `RUNNING`   | running     |
| `COMPLETED` | completed   |
| `PARTIAL`   | partial     |
| `FAILED`    | failed      |