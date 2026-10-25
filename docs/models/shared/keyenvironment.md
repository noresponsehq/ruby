# KeyEnvironment

The environment the key belongs to. A live key assesses with live sources; a test key answers from the deterministic simulator.

## Example Usage

```ruby
require "noresponse"

value = KeyEnvironment::LIVE

# Open enum: use .deserialize() to create instances from custom string values
custom = KeyEnvironment.deserialize("custom_value")
```


## Values

| Name   | Value  |
| ------ | ------ |
| `LIVE` | live   |
| `TEST` | test   |