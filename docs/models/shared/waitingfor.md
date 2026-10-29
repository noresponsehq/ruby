# WaitingFor

## Example Usage

```ruby
require "noresponse"

value = WaitingFor::OUTCOME

# Open enum: use .deserialize() to create instances from custom string values
custom = WaitingFor.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `OUTCOME` | outcome   |
| `REVIEW`  | review    |