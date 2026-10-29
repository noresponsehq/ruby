# MemberEnvironment

## Example Usage

```ruby
require "noresponse"

value = MemberEnvironment::LIVE

# Open enum: use .deserialize() to create instances from custom string values
custom = MemberEnvironment.deserialize("custom_value")
```


## Values

| Name   | Value  |
| ------ | ------ |
| `LIVE` | live   |
| `TEST` | test   |