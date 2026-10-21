# Freshness

Freshness class of the evidence behind a signal. unknown whenever no evidence was obtained.

## Example Usage

```ruby
require "noresponse"

value = Freshness::FRESH

# Open enum: use .deserialize() to create instances from custom string values
custom = Freshness.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `FRESH`   | fresh     |
| `STALE`   | stale     |
| `UNKNOWN` | unknown   |